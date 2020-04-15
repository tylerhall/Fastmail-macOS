# Fastmail-macOS
A macOS wrapper around [Fastmail.com](https://www.fastmail.com) that supports multiple accounts and notifications.

It should go without saying that this dumb little project is in no way affiliated with or endorsed by the wonderful people at [Fastmail](https://www.fastmail.com). I trust they won't yell at me too much for also using their logo for the app icon.

### Download

I've posted a Developer ID signed and notarized build if you'd like to just download and run the app. Otherwise, feel free to download the source, inspect it to make sure I'm not doing anything shady, and build the project yourself. There are no 3rd party dependencies. Pressing ⌘R in Xcode should be sufficient to build and run the app.

[View and download releases here](https://github.com/tylerhall/Fastmail-macOS/releases/tag/v1).

### Security

It's worth pointing out that this app does absolutely nothing with your Fastmail credentials. It doesn't read them or transmit them (or _any other_) information off your Mac. The only network connections are between the webviews in the app and the Fastmail website.

## Project Status

It works for me.

Supports multiple accounts and native macOS notifications for new emails. Also plays the lovely default Mail.app "ding" when email arrives.

## To Do

* Oh, me oh my. The whole app is such an incredible hack of hidden webviews to make monitoring for new emails work no matter which page of the Fastmail.com website you're viewing. If I (or anyone) ever gets the time or motivation, it would be terrific to kill the extra webviews and just check for new emails using JMAP.
* Might also be interesting to bind native macOS keyboard shortcuts to Fastmail actions like Mailplane does for Gmail. But, honestly, Fastmail already has great keyboard support, so this is very low on my list.
* It would be nice to make a real Preferences window to manage accounts rather than my quick and dirty textview parsing stuff.
