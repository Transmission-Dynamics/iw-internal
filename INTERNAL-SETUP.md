# internal.jrdltd.co.uk: what Steve does

A page of tiles that sends staff to askSOPHIE, askTIMELY and the rest. It is
plain HTML served off the disk. No Node, no service, no database, no sign-in
of its own, nothing to back up: if the folder is there, the page works.

Internal only, the same as askSOPHIE.

## 1. DNS

Create `internal.jrdltd.co.uk` pointing at the server, on the internal
network only. It does not need to resolve from the internet and should not.

## 2. Certificate

The same one askSOPHIE uses if it is a wildcard for `*.jrdltd.co.uk`;
otherwise a certificate for this name.

## 3. The folder

On the server, next to the `asksophie` folder:

    git clone --branch live https://TOKEN@github.com/Transmission-Dynamics/iw-internal.git internal

with the same iw-server token askSOPHIE now uses in place of TOKEN.

## 4. Apache

A vhost on 443 for `internal.jrdltd.co.uk` with the certificate, and:

    DocumentRoot "C:/path/to/internal/public"
    DirectoryIndex index.html

Keep the internal-IP `Require ip` rule that the askSOPHIE vhost has, so it
answers on the work network and the VPN and nowhere else. There is no proxy
and no port to open: Apache reads the file itself.

Reload Apache.

## 5. Keeping it up to date

Copy the scheduled task that runs askSOPHIE's `update.bat` every minute and
point the copy at this folder's `update.bat`. It pulls the `live` branch and
stops. There is no service to restart, so a deploy is invisible: the next
person to load the page gets the new one.

If a task every minute is more than this deserves, every fifteen is plenty --
the page changes a few times a year.

## 6. Tell Murven

That the hostname resolves and the page loads over HTTPS from a desk.

## Rollback

    cd internal
    git reset --hard <the previous commit>

and the page is back. Nothing else holds any state.
