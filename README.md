# DO NOT USE IF YOU ARE ON BIG SUR. OSX DOES NOT ALLOW IT TO RUN.

# APPLESCRIPT FOR AFTER EFFECTS
See it in action: https://youtu.be/q6TleS-IJ4s

![poster](https://p1.f0.n0.cdn.getcloudapp.com/items/KouWqRzo/Screen+Shot+2020-02-27+at+12.40.01+PM.png?v=4a09f05351f3a0c8624d7ccf9add9ba5)


This script requires you to have already installed:
* [After Effects](https://www.adobe.com/products/aftereffects.html)


I wrote this little app using the built-in Script Editor in OSX.

The app will ask you:

- The location of the aerender file (this is located right in your After Effects folder). The app will ask you only once when you launch the app for the first time or if the aerender file has been deleted (usually after the installation of a newer version of After Effects).
- The .aep file you want to render (you can render multiple .aep files by launching the app multiple times).
- The desired frames per second (this is needed for the .mov and .mp4 files).
- If you want to turn off the system after it finishes.

The app will create:

- 1 .mov, ProRes 4444 (in the same location of your .aep file).
- 1 .mp4, crf= 12 (1 without sound in the location of your .aep file and another with sound in any location you choose).
- Multiple instances of the same render (using OSX Terminal).

# This is the main reason I wrote this script in the first place

As you probably know, After Effects can be extremely slow to render. This is because it renders 1 frame at a time, limiting the amount of resources AE can access. This is the easiest (and free) way I found to force AE to use all CPU cores.

These "instances" are doppelgängers of the render. This way, we can output multiple frames in parallel, decreasing the rendering time up to 10 or 20 times (depending on your hardware).

For each instance, you can reduce around 15% of your render time.

Example: If your render from AE takes 10 minutes, choosing:

- 2 instances (30%) should reduce your render to 7 minutes.
- 4 instances (60%) should output your render in 4 minutes.
- 6 instances (90%) should output your render in less than 1 minute.
- and so on...

And you are saving even more time since the app takes care of creating both .mov and .mp4 files. So, usually, you should add to those 10 minutes AE the time it takes to open other apps and render your files to these formats, and you don't even have to start After Effects.

Just beware that each instance might take around 2 or 4GB of RAM. So, for a 12-core CPU, ideally, you might want 24 or 32GB of RAM. Still, you can pick as many instances as you want depending on your current hardware.

# APP Requirements (since v1.4)

The only requirement the app needs at the moment is to enable Terminal in Accessibility.

- The app no longer needs access to the accessibility features, BUT, Terminal does. This is good news because you are giving access to these features to an OSX app instead of the one I made and you only need to do it once, ever. There is a video included that shows how to do this.

That's all. The app will take care of everything else.

NOTE: The included demo is made for 60fps. Failing to input the correct fps for any .aep file will result in the app endlessly trying to fix the render output. If this happens, you will have to force quit the app. (Right-click on the dock icon + ⎇)

# DOWNLOAD IT ON THE RELEASES TAB

Questions or ideas? Reach me on telegram: @davidescalante
