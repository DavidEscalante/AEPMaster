# APPLESCRIPT FOR AFTER EFFECTS
See it in action: https://youtu.be/q6TleS-IJ4s

![poster](https://p1.f0.n0.cdn.getcloudapp.com/items/KouWqRzo/Screen+Shot+2020-02-27+at+12.40.01+PM.png?v=4a09f05351f3a0c8624d7ccf9add9ba5)


This script requires you to have already installed:
* [After Effects](https://www.adobe.com/products/aftereffects.html)


I wrote this little app using the build in Script Editor in OSX.


The app will ask you

- The .aep file you want to render
- The desire frames per second (this is needed for the .mov and .mp4 files)If you want to turn off the system after it finish

La aplicación will create

- 1 .mov, ProRes 4444
- 1 .mp4, crf= 12
- Multiple instances of the same render

# FORCING AFTER EFFECTS USING MULTIPLE CORES

As you probably know, After Effects can be extremely slow to render, this is because it renders 1 frame at a time, limiting the amount of resources AE can access, this is the easiest (and free) way I found to force AE to use all CPU cores.

These "instances" are doppelgängers of the render, this way we can output multiple frames in parallel, decreasing the rendering time up to 10 or 20 times (depending on your hardware).

For each instance you can reduce around 15% your render time

Example: If you render from AE takes 10 minutes, choosing:

- 2 instances (30%), should reduce your render to 7 minutes
- 4 instances (60%) should output your render in 4 minutes
- 6 instances (90%) should output your render in less than 1 minute
- and so on...

And you are saving even more time since the app takes care for creating both .mov and .mp4, so usually you should add to those 10 minutes AE the time it takes to open other apps and render your files to these formats,  and you don't even have to start After Effects.

Just beware that each instance might take around 2 or 4GB of RAM, so for a 12 core CPU, ideally you might want 24 or 32GB of RAM, still, you can pick as many instances you want depending on your current hardware.

# APP Requirements

There are 2 requirements at the moment that the app need to work:

- The app **needs access to the accessibility** features in OSX. This is needed so the app can send ⌘T shortcuts to the Terminal window so it can create multiple tabs, each one for each instance the user chooses to create.
- **You .aep file must share the name of the composition you want to render:** If the comp you want to render is called "finalmaster1080" your .aep file **must** be called "finalmaster.aep"

Thats all, the app will take care of everything else

# DOWNLOAD IT ON THE RELEASES TAB

Questions or ideas, reache me here: http://zanate.com.mx/id/

