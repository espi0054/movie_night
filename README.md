# Movie Night Flutter Application 

The Movie Night App is an app meant to be used by two people simultaneously to help people choose a movie to watch together.

## Description of the project:

The app has four screens.

1. A welcome screen where they choose to be the person starting the session or the person entering the shared code.
<img title="welcome screen" src="/assets/images/welcome_screen.png" width="200">

2. A screen that creates the code to share with the other user, and then being the movie matching.
<img title="code sharing" src ="/assets/images/code_sharing.png" width="200">

3. A screen that lets the second user enter the code, and then begin the movie matching.
<img title="code sharing" src ="/assets/images/friends_code.png" width="200">

4. The movie selection screen talks to The Movie DB API (opens new window)to fetch the most recent or most popular or upcoming movies, 20 at a time. The app talks to the MovieNight API found. The home route for the API provides a list of the other API endpoints, along with their required Request parameters and the properties in the Response object.
<img title="welcome screen" src="/assets/images/pic1.png" width="200">

## How to run the app 

1. Clone the repo 
```
git clone https://github.com/espi0054/movie_night.git
```

2. Open the file

3. Installing dependencies packages:
```
flutter pub get 
```
4. Run the app:
```
flutter run 
```