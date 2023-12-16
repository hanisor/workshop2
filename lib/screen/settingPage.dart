import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  void handleTelegramSettings() {
    // Add logic for handling Telegram settings here
  }

  void handleAlertNotificationSettings() {
    // Add logic for handling alert notification settings here
  }

  void handleLogout() {
    // Add logic for handling the logout action here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Center(child: Text('Settings')),
        backgroundColor: Colors.green[900], // Set app bar color to green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: handleTelegramSettings,
              child: Text('Account', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // Set button color to green
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAlertNotificationSettings,
              child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // Set button color to green
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              }, child: Text('Notifications', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor : Colors.green[900], // Set button color to green
                ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAlertNotificationSettings,
              child: Text('Feedback and Info', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900], // Set button color to green
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleLogout,
              child: Text('Logout', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // Set button color to green
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {
                // Handle activity icon press
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                // Handle feedback icon press
              },
              icon: Icon(Icons.feedback),
            ),
            IconButton(
              onPressed: () {
                // Handle graph icon press
              },
              icon: Icon(Icons.bar_chart),
            ),
            IconButton(
              onPressed: () {
                // Handle profile icon press
              },
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }
}
