# Hearing Test for Mimi

## Technical Details
* **Design Pattern** : MVVM with Reactive approach is applied. Combine is used for functional reactive programming because it's native to Apple. 
* **Dependency Injection** : DI is applied using Swinject [https://github.com/Swinject/Swinject] 
* Also Protocol Oriented, Key-Value Observer(Notification Center) and Delegation patterns are used. 
* **Nib** files are used for UI creation (every screen has a nib) 

## Usage Details
* Requires iOS 15.0 or later
* You need to have your headphones connected to use the app. It can be plugged-in or any other bluetooth earphone/headphone such as Airpods. 
* In screens of 'Preparation', 'Test', it will prompt a pop-up if your headphones are disconnected. You cannot dismiss the pop-up unless you connect your headphones. 

### Enjoy!
