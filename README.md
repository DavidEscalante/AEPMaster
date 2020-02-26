# APPLESCRIPT FOR AFTER EFFECTS

This script requires you to have already installed:
* [ffmpeg](https://www.ffmpeg.org/download.html)
* [mediainfo](https://mediaarea.net/es/MediaInfo)
* [iTerm](https://iterm2.com) 

This is an AppleScript that you can turn into an OSX app using the build-in Script Editor in OSX.

Because After Effects (at the time of writing this) only uses 1 core a frame, this makes rendering extremely slow, specially for computer with multiple cores CPUs.

I wrote this script some couple of years ago for automating tasks, like creating multiple mp4 files with different soundtracks, and to upload each .mp4 to each client directory automatically, so I could let the script to render multiple projects and don't have to worry about anything else.

It also creates multiple render instances of the same rendering process, forcing AE to use as many computer power as your system allows it, is a "brute force" approach, but you can get as 10 times faster render output than the default settings.

**Just beware that each process uses its own amount of ram, having 2 to 4 gigabytes of RAM for instance is recommended:**
If you have a 6 core CPU, you may want to pick 6 instances, meaning you should have around 24 gigabytes of ram available.

=========================

**AEPMaster**
This script allows you to select an .aep (After Effects project) file. Once the file is selected the script will:

**Ask you**
* For the project frame rate, this is needed to create the .mp4 files.
* If you want to shutdown the computer once the creation of both .mp4 and .mov files are done.
* The amount of instances you want to create.

**Create**
* A folder called "_OUTPUT" in the same location of the .aep file you chose, in this folder the instances will render the project as .psd sequences
* An .aiff file, regardless if the project have or not audio, this is important.
* FFMPEG: A .mov with ProRes 4444 configuration, it will merge the previously created .psd sequences.
* FFMPEG: A .mp4 from the previous .mov file

=========================

Using mediainfo, the scrip will compare the .aiff file with the rendered .mov file, if both files time match, it means the video is rendered correctly, if there is a difference between these two, the render will restart and will keep going until these two files match exactly.

This is because, SOMETIMES, some After Effects instances might refuse to initiate, leaving ghost files behind, because these ghost files, the .mov might render incomplete or with the wrong duration, using the .aiff file with mediainfo, we can capture the duration of the whole project and then be sure if something is missing.

If you have any questions, [you can reach me here](http://zanate.com.mx/id)

