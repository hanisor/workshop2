import 'package:flutter/material.dart';
import '../model/educatorModel.dart';
import '../model/parentModel.dart';

class UserDetailsContainer extends StatelessWidget {
  final ParentModel? parent;
  final EducatorModel? edu;

  const UserDetailsContainer({
    this.parent,
    this.edu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange[50], // Set the background color here
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange[900], // Set the icon color to orange
                ),
                SizedBox(width: 5),
                Text(
                  "User Information",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.orange[900], // Set the text color to orange
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: parent != null
                      ? NetworkImage(parent!.parentProfilePicture)
                      : NetworkImage(edu!.educatorProfilePicture),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parent != null ? parent!.parentName : edu!.educatorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        parent != null ? parent!.parentFullName : edu!.educatorFullName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        parent != null ? parent!.parentEmail : edu!.educatorEmail,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 5),
                      Text(
                        ('~ ${parent != null ? parent!.role : edu!.role} ~'),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      if (edu != null && edu?.educatorExpertise != null)
                        Text(
                          edu!.educatorExpertise,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
