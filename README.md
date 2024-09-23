# FreeFileSync

FreeFileSync is a folder comparison and synchronization software that creates and manages backup copies of all your important files. Instead of copying every file every time, FreeFileSync determines the differences between a source and a target folder and transfers only the minimum amount of data needed. FreeFileSync is Open Source software, available for Windows, macOS, and Linux.

## Alternatives

- Rclone
- Restic
- rsync
- Syncthing
- TeraCopy

## Vision

> Source: [Vision - FreeFileSync](https://freefilesync.org/vision.php)

The FreeFileSync creator, Zenju, shares his thoughts about the project's history, purpose, and direction in an interview after FreeFileSync was elected Project of the Month on SourceForge.

### Tell me about the FreeFileSync project

FreeFileSync is a graphical file synchronization and folder comparison tool. This means that its main purpose is to speed up backup operations by examining the differences between source and target folders, and then only copy what is really needed rather than copy everything each time like disk cloning/imaging tools do.
Since synchronization is usually very fast and can be automated by creating batch jobs, it is easy to always have your important files backed up in a second location — without needing any cloud services at all.

The second core feature is folder comparison: With FreeFileSync, you can binary-compare entire folders and see exactly where the difference is. This is similar to what file diff tools do, but at a folder level. BTW file diff tools can be integrated into FreeFileSync, too.

### What made you start this?

When I started the project, I was looking for a file synchronization tool because I was traveling back and forth between two locations and needed my multi-gigabyte data to be in sync on two PCs. So conceptually my requirement was simple, but I was not happy with the tools I found: They were mostly overly complex, often slow, and were lacking good error handling. After seeing one "unknown error" message too many, I decided this problem should be solved starting from first principles. So, I set out a number of goals that FreeFileSync should strive for:

No needless user interface complexity: A good number of options can be avoided by finding a different, smaller set that better suits the task at hand. Another big fraction can entirely be avoided by having the software make smart decisions itself whenever it can do so without risk.
Having an academic background in mathematics, I like to think that good software design is finding the base vectors of the problem domain: If you have too few "vectors" (= program capability), your software doesn't satisfy enough of your users' needs. If you have too many, you are bloating the software with redundant options. Ideally, just like a good set of base vectors for a vector space, features of a software should be orthogonal, which can be translated as having minimal dependencies between each other while maximally expanding into the problem domain.

Having worked professionally mainly in the area of software performance optimization, another goal for FreeFileSync was to have excellent performance. In other words, if I were to find a file synchronization tool that was faster than FreeFileSync I would take it as a challenge and not stop until FreeFileSync is at least equally fast. Since file synchronization is inherently I/O bound, optimal performance can be defined as the time needed to complete the minimum number of I/O operations for a task, while the CPU time should be so short as to be negligible.

Good error handling: Each and every operation should pedantically be checked for errors and in case errors are detected, the maximum amount of useful information should be returned to the user. Reliability is key for a file sync tool, and before FreeFileSync I found the lack of both consistent error checking and reasonable error messages unacceptable in the popular tools. The premise for FreeFileSync is: If no errors are reported, then the user can rest assured that all went well.

### Has the original vision been achieved?

Deciding which features to support is a tough battle. Not every feature that is essential for a single user justifies its exposure to the full FreeFileSync user base. On the other hand, more often than not, highly specific scenarios can be supported by only making a number of small changes to the software without increasing the total complexity. In the vector space metaphor, it's like changing the direction of some base vectors. Frequently new requirements can be handled without the proverbial adding of "just another check box". Understanding the problem in its entirety is the hard part and takes time and openness to any kind of user feedback. Now years after its initial conception, I'm proud to say FreeFileSync has not compromised on its ideals in software design. There is no legacy of historical features that could impede future software development.

I have not yet seen a faster synchronization software. The results of performance measurements for FreeFileSync show that except for the essential I/O the fraction of additional time consumed is in the low percent areas. Additionally, FreeFileSync tries to keep the machine busy by doing as much work in parallel as possible. For example, all folders are scanned at the same time, so if you are scanning ten slow hard disks in a single job, you only have to wait the time that it takes to scan a single one of them.

FreeFileSync's error messages significantly reduce the overall support effort because they enable most users to help themselves. Error messages are structured into multiple levels, first providing a high-level overview on what went wrong, followed by more detailed context information and are even going further down to operating system error codes for maximum detail. All the information can be copy-pasted and is formatted in a way that gives good results when entered into a search engine.
This takes a lot of pressure from the FreeFileSync support forums, because users can find a solution to a specific problem much quicker.

### Who can benefit the most from your project?

FreeFileSync is suited for everyone who wants to back up their important files regularly. The idea is to set up a sync configuration once and use it from there on. This reduces the mental overhead required to do a backup to a single mouse button click (on a FreeFileSync batch file). If you want even more automation, you can schedule FreeFileSync to run in a task planner or synchronize a folder in real time on each detected change with RealTimeSync, an application coming bundled with FreeFileSync.
Backup is not only needed when disaster strikes, but frequently when you need an earlier version of a particular file or document. In a non-technical sense, FreeFileSync helps you sleep better, knowing that recent versions of your files are safe. I sure know it did help me.

As far as tech know-how is concerned, FreeFileSync requires no special knowledge. No matter if casual PC user or IT administrator, both should find their way in FreeFileSync. I firmly believe that expert users want nice and easy-to-use software, too, so why complicate a program with "easy" and "advanced" modes?

### Did more frequent releases help build up your user community?

FreeFileSync releases updates about once every month and has been doing so since its first release. From a software development perspective, this provides all the benefits that are expected from short release cycles nowadays: Bug fixes reach users very quickly, solving problems before they may have a negative impact. This naturally increases the confidence in that the program is stable and well-maintained. Also, severe bugs are less likely to occur in first place because the changes among versions are not as pervasive as for software created following traditional methodologies (like waterfall) and which release maybe once a year.

Frequent releases force you to rigidly streamline the complete development process, including packaging, testing, and localization. All of this takes considerable initial effort, but pays off: If a severe bug was to be found in FreeFileSync, it's possible to ship an out-of-order bug-fix release on the very same day, while users are notified by the built-in auto-updater. This is an essential property for a software that needs to scale to a large number of users who may critically depend on its functionality. Considering all the years that FreeFileSync has been releasing regularly, this consistency helped to build a community of users who are confident about the quality of the backup software they are using.

### What is the next big thing for FreeFileSync?

The most-requested feature currently is synchronization with smart phones. This is our top priority and will be in one of the future versions of FreeFileSync. However I can't make any promises when it will be available. [Update: synchronization with MTP devices is available since FreeFileSync 7.0]

### If you had it to do over again, what would you do differently?

FreeFileSync takes a drastic approach concerning software development: If something is not right, be it software design or source code, it will be fixed, no matter how small or insignificant the problem might seem. This may sound like a lot of work for tiny problems, but it pays off significantly in the long run when applied consistently. The complete code base, not only of FreeFileSync, but all my software projects always matches the current level of my expertise. Whenever I learn something new, I apply it and fix it everywhere. With my understanding of both technical and human interface problems deepening, the number of things to fix becomes smaller over time and the amount of time to invest shrinks. At the same time, it's a huge strategic advantage because working on the FreeFileSync code base is always fun when there is no historical baggage left. The advantages of constant code refactoring are well-known and in the case of FreeFileSync provably so.
The biggest impact on the software as a whole in this regard has been the C++11 standard [Update: now it's C++23], which had a profound impact on the code base. As soon as the common set of features supported by compilers on Windows, macOS, and Linux allowed it, the FreeFileSync code has gradually migrated to using the most recent and improved ways of programming.
Software is taken literally and whenever there is something that should have been done differently, it is never too late to just do it now.

### Is there anything else we should know?

I would like to thank everyone who has contributed to the project! Thanks in particular to everyone who donated and to my group of dedicated translators who have supported me reliably over all the years. Also, thanks to all of the users reporting feature requests and bug reports that help to improve FreeFileSync even further.

Zenju
December, MMXIV
