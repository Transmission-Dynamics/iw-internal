# internal.jrdltd.co.uk

The way in to Transmission Dynamics' own applications: one page of tiles that
sends people to askSOPHIE, askTIMELY and whatever comes after them. It is a
signpost, nothing more. It holds no data, has no sign-in of its own and keeps
no record of who passed through it, so there is nothing here to back up.

    public/index.html    the whole thing
    update.bat           the server pulls the `live` branch every minute

## Changing it

Everything is in `public/index.html`: the tiles are near the bottom of the
file and read like the page does. To add an application, copy one of the four
tiles, give it a colour in the `:root` block at the top, and point the `href`
at its address. A tile for something that is not built yet is a `<div>` with
`class="app waiting"` rather than an `<a>`, so it says "coming soon" without
pretending to be a door.

## How it reaches the server

The same way askSOPHIE does, minus the service: commit to `main`, look at it,
then merge `main` into `live` when it is ready to be seen. The server pulls
`live` every minute and Apache serves the folder straight off the disk, so
there is nothing to restart -- the next person to load the page gets it.

Set-up for the server is in `INTERNAL-SETUP.md`.
