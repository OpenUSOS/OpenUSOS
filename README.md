![](fastlane/metadata/android/en-US/images/icon.png)
# OpenUSOS
## Authors: Oskar Kuliński, Filip Ciebiera, Wieńczysław Włodyga   
### Current version: 1.0.0

### An open source unofficial USOS app, for students in Poland.
Here you can
- set and receive notifications about upcoming classes
- view your grades
- view your test results
- check your class schedule
- see the academic year calendar and add your own events to it
- fill out university surveys
- send emails to university staff

Currently supported universities
- Uniwersytet Jagielloński
- Politechnika Wrocławska
- Chrześcijańska Akademia Teologiczna w Warszawie.


We use our own server to communicate with the USOS system. You can view its code here:
https://github.com/OpenUSOS/OpenUSOS-server


Our plans for the future:
- speed up the app
- improve the look of emails
- add viewing course groups
- in app bug reporting
- release on Google Play Store
- add notifications about upcoming registrations
- add registration for classes
- start work on an IOS release

## Screenshots 
Some screenshots for you to admire the amazingness of our app

<img src="fastlane/metadata/android/en-US/images/screenshot_schedule.png" 
alt="You can view your class schedule" 
width="336" height="748"/>
<img src="fastlane/metadata/android/en-US/images/screenshot_surveys.png"
alt="You can see what surveys are available for you to fill" 
width="336" height="748"/>
<img src="fastlane/metadata/android/en-US/images/screenshot_survey_filler.png"
alt="You can fill your surveys" 
width="336" height="748"/>
<img src="fastlane/metadata/android/en-US/images/screenshot_settings.png"
alt="You can set how much time before a class you want to receive notifications" 
width="336" height="748"/>
<img src="fastlane/metadata/android/en-US/images/screenshot_tests.png"
alt="You can see your test results \(and a dark mode is available, as you might have noticed\)" 
width="336" height="748"/>
<img src="fastlane/metadata/android/en-US/images/screenshot_calendar.png"
alt="You can check the academic calendar to see when you have a day off, easily visible with icons" 
width="336" height="748"/>
<img src="fastlane/metadata/android/en-US/images/screenshot_event_adding.png"
alt="You can add your own event to the calendar, so you don't forget about an exam" 
width="336" height="748"/>


## Contributing
- If you want to report a bug, you can do so by opening an issue here 
https://github.com/OpenUSOS/OpenUSOS/issues    
- If you want to make some visual changes to the app you can edit 
*lib/pages/whatever_page_you_want_to_improve.dart*
The file names there should be pretty self explanatory, with every page having its own file 
- You can also modify the *lib/themes.dart* file, where our themes are stored
- If you want to add a new feature all by yourself you need to add it both in the app, and the server
- If you can/want to do it in only one place, let us know, we will do our best to help you out, 
and implement the feature on the other side
- If you want to help us out financially, an option will be available soon

## Self hosting
The app uses our server to communicate with the USOS system. If you want additional security feel
free to host your own instance of the server. All you have to do is change the UserSession.host
to the address of your server in lib/user_session.dart and follow the steps in here:  
https://github.com/OpenUSOS/OpenUSOS-server/blob/main/README.md#self-hosting

## Making your own server
https://github.com/OpenUSOS/OpenUSOS-server/blob/main/README.md#making-your-own-server
