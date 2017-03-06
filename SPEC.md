**What happens when I load the tag view page?**
Seems OK to me as is.

**Then, what happens when I click play?**
`POST api/2/streams/`
send `latitude` and `longitude` only if `geo_listen_enabled=TRUE`
Client waits for server response and plays audio from returned `stream_url` when received
If no `stream_url` is returned, client error should be displayed. We can talk about those details.
I think ultimately after the audio starts playing on the client, a `PATCH api/2/streams/` call should be sent containing the default listen tags. For now, we can stick with the logic you built in which, I believe, sends a `PATCH` call with the first tag in the GUI display.

**What happens when I click a tag?**
`PATCH api/2/streams/` with the new tag id as parameter
Continue playing audio stream with no pause; the current asset will fade out and a new asset for the new tag will fade in shortly thereafter. Currently the fade-out doesn’t work, but will soon.

**What happens when I click that same tag?**
I haven’t really considered this much, but if the active tag is clicked again, I don’t think anything should happen since it is already active. If another tag has become active in the meantime and the user wants to go back to the previously listened tag, the same `PATCH` call should be sent. I don’t think the server would care if the `PATCH` call was sent even in the active tag situations, but I’d have to investigate.

**What happens when I click next?**
`POST api/2/stream/:id/next`
NOTE: this is not currently functioning on server, but will be soon

**What happens when I click previous?**
`POST api/2/stream/:id/previous`
NOTE: this is not currently functioning on server, but will be soon

**What happens when I switch rooms?**
`PATCH api/2/streams/` with tag id for new room as parameter

**What happens when I load a map?**
I have no idea what people want with the map screen. Personally, I think it doesn’t make sense to have a map unless we are using interior location, but for some reason, other folks want the map. My understanding is that they want a full-screen vector map of the site loaded that can scroll and zoom. I will investigate.

**What happens when I background the app?**
My understanding is that there are several ways an app can be backgrounded (screen dimming, other app opened, phone/text/etc interrupt…maybe others?), but I don’t pretend to understand the intricacies of iOS in this regard. I think either way, the app should continue to function i.e. playing audio and updating the stream as necessary, unless it is an audio interrupt in which case the audio will stop playing and the stream should be paused just as if the Pause button was pressed. Likewise, when the audio interrupt is over i.e. phone call ends, the stream should be un-paused.

**What happens when I resume the app?**
I think the above answers this?

**What happens when I lose my connection?**
If connection is lost for long enough that the stream runs out of buffer, a popup notification should display telling the user that audio streaming is only possible when a data connection is in place. The LISTEN functionality should be disabled and the button disabled as well to minimize confusion. The app can still function in SPEAK mode as Roundware can record assets, store them locally and upload them once back online.

**What if I am not on wifi?**
I don’t think wifi vs. data connection makes any difference?

What happens when someone locks their screen?
see backgrounding response above. App should continue to play and update stream.

**What happens when I walk around?**
Nothing if `geo_listen_enabled=FALSE` but if `TRUE`, every time a new position comes in via CoreLocation, a `PATCH api/2/streams/` is sent with the new `latitude` and `longitude` as parameters.

**What happens when all the assets in a tag complete?**
This is something that we were hoping to get feedback on from testers. My inclination is when `geo_listen_enabled=FALSE` the app PATCHes the stream with the next tag in the GUI, if one exists. When `geo_listen_enabled=TRUE` nothing should happen; the app should wait until the user moves to a new location where there is more unheard content.

**What should the UI do while waiting for an asset to start playing back?**
The UI should display a spinner when waiting for the `stream_url` initially or while the stream is buffering when returning to listening after contributing. As far as assets in the stream go, I think the GUI should reflect the current or most recent asset played by highlighting that tag GUI element. So when waiting for an asset, it shouldn’t change from the last asset played until the new asset starts.

**What happens while the stream is playing, i.e. what is the purpose of the heartbeat? What data should it include or not include?**
The purpose of the `heartbeat` is to keep a stream alive when it is likely to be used again while ensuring that streams don’t continue to exist after they are no longer needed. The server will automatically kill streams if there is no activity on a stream for a period of time (default is 200 seconds, I believe). The reason for this is that stream generation is resource intensive on the server so we don’t want to waste effort keeping streams going that are no longer needed.

The `heartbeat` is a benign method for telling the server that activity is still happening on a particular stream so it should not be killed. Stream “activity” is defined as any api calls involving the stream’s id or active listening of the stream (as tracked by Icecast). So there is no need to send heartbeats when the stream is being listened to, but when the user is contributing or the stream is paused, we want to send heartbeats periodically to make sure their stream is alive when they are done and want to listen again. When the user quits the app, no more heartbeats are sent and the stream is killed after 200 seconds.

Due to my lack of knowledge on app backgrounding, I’m not sure if we will want to consider some more detailed control here, like if the app is backgrounded and not being listened to, don’t send heartbeats because that probably means the user is done…?

**What happens when I tap contribute?**
this flow looks pretty good to me in the current app...

**What should the time on the left of the UI show and where should that time come from?**
Which screen? Listen? I see the two counters on that screen in the app, but in my screen flow pdf, I only see one counter. My understanding was that this was supposed to count down the remaining time for the current asset. This was a topic of some debate during the design process, so we were going to wait for some testing feedback before implementing something here, as best I recall. If it is a countdown time for the current asset, we would need to have the server provide you with the length, which we could do in the stream metadata, most likely.

**The one on the right?**
see above

**Anything else that should be specified?**
I’m guessing there is more, but for now will let you follow-up with more questions unless I think of anything to add.
