import { Temporal } from "temporal-polyfill"

// 2/3rds of this file is just dealing with google's Oauth, just let me use a damn api key vroo :sob:
const CLIENT_ID = process.env.CLIENT_ID!
const CLIENT_SECRET = process.env.CLIENT_SECRET!
if ([CLIENT_ID, CLIENT_SECRET].some(x => x === undefined)) {
  console.error('CLIENT_ID and CLIENT_SECRET not set in .env, see .env.example')
  process.exit()
}
let ACCESS_TOKEN = process.env.ACCESS_TOKEN
let ACCESS_TOKEN_EXP = process.env.ACCESS_TOKEN_EXP
let REFRESH_TOKEN = process.env.REFRESH_TOKEN

if ([ACCESS_TOKEN, ACCESS_TOKEN_EXP, REFRESH_TOKEN].some(x => x === undefined))
  await getToken({ useRefreshToken: false }) // first run, get initial tokens
if (Number(ACCESS_TOKEN_EXP) < Temporal.Now.instant().epochMilliseconds)
  await getToken({ useRefreshToken: true }) // update tokens using refresh
console.log(JSON.stringify(await getEvents(), null, 2))

function updateDotEnv() {
  const content = Object.entries({ CLIENT_ID, CLIENT_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_EXP, REFRESH_TOKEN })
    .map(([k, v]) => `${k}=${v}`)
    .join("\n")
  Bun.write(".env", content)
}

function getAuthorizationCode() {
  if (!process.stdin.isTTY) {
    console.error("auth required");
    process.exit(1); 
  }
  
  const authorizationCodeURL = `https://accounts.google.com/o/oauth2/v2/auth?${new URLSearchParams({
    scope: 'https://www.googleapis.com/auth/calendar',
    response_type: 'code',
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
    client_id: CLIENT_ID,
  })}`
  
  const authorizationCode = prompt(`${authorizationCodeURL}\nauth code:`)!.trim()
  if (!/^\d\/[\w-]{60}$/.test(authorizationCode)) {
    console.error('invalid auth code, try again')
    return getAuthorizationCode()
  }
  return authorizationCode
}

interface TokenData {
  access_token: string
  refresh_token?: string
  expires_in: number
  // also `{ scope: string; token_type: "Bearer" }` but I'll never touch those
}
async function getToken({ useRefreshToken }: { useRefreshToken: boolean }) {
  const token = await fetch('https://www.googleapis.com/oauth2/v4/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
      
      grant_type: useRefreshToken ? 'refresh_token' : 'authorization_code',
      code: useRefreshToken ? undefined : getAuthorizationCode(),
      refresh_token: useRefreshToken ? REFRESH_TOKEN : undefined,
    }),
  }).then(r => r.json() as Promise<TokenData>)
  ACCESS_TOKEN = token.access_token
  ACCESS_TOKEN_EXP = (Temporal.Now.instant().epochMilliseconds + (token.expires_in * 1000)).toString() // expires_in is how many seconds until the token is expired
  if (token?.refresh_token) REFRESH_TOKEN = token.refresh_token
  updateDotEnv()
}

interface GCalEventTimingInfo { dateTime?: string; date?: string }
interface GCalEvent {
  status: string
  htmlLink: string
  summary: string
  start: GCalEventTimingInfo
  end: GCalEventTimingInfo
}
interface Event {
  title: string
  link: string
  startMs: number
  endMs: number
}
async function getEvents(): Promise<Array<Event>> {
  const now = Temporal.Now.instant()
  const eventResp = await fetch(`https://www.googleapis.com/calendar/v3/calendars/primary/events?${new URLSearchParams({
    timeMin: now.toString(),
    timeMax: now.add({ hours: 24 }).toString(),
    singleEvents: 'true', // expand reoccurring events into seperate instances
    orderBy: 'startTime',
  })}`, {
    headers: { Authorization: `Bearer ${ACCESS_TOKEN}` },
  }).then(r => r.json() as Promise<{ items: Array<GCalEvent> }>)
  
  const gcalEvents = eventResp.items
    .filter(event => event.status === 'confirmed') // no canceled/tentative
    .filter(event => event.start?.dateTime !== undefined) // no all-day events
  
  return gcalEvents.map(event => ({
    title: event.summary,
    link: event.htmlLink,
    startMs: Temporal.Instant.from(event.start.dateTime!).epochMilliseconds,
    endMs: Temporal.Instant.from(event.end.dateTime!).epochMilliseconds,
  }))
}
