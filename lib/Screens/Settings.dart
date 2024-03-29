import 'package:ehs_new/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'CompanyName.dart';

class Settings extends StatefulWidget {
  static String tag = '/Settings';

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontFamily: 'RocgroTesk', fontSize: 21),
        ),
        backgroundColor: Color(0xFF145d87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              "Media Auto-upload",
              style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildToggleOption(
              icon: "images/app/icons/mobiledata.svg",
              title: "When using mobile data",
            ),
            SizedBox(height: 20),
            _buildToggleOption(
              icon: "images/app/icons/wifi.svg",
              title: "When connected on Wi-Fi",
            ),
            SizedBox(height: 40),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption({required String icon, required String title}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            icon,
            width: 40,
            height: 40,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          Spacer(),
          ToggleSwitch(
            minWidth: 50,
            initialLabelIndex: 1,
            cornerRadius: 20,
            activeBgColor: [Color(0xFF145d87)],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            labels: ['Yes', 'No'],
            onToggle: (index) {
              print('switched to: $index');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyName(),
            ),
          );
          // Show toast message
          Fluttertoast.showToast(
            msg: "Logged out successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF145d87),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// class Settings extends StatefulWidget {
//   static String tag = '/Settings';
//
//   @override
//   SettingsState createState() => SettingsState();
// }
//
// class SettingsState extends State<Settings>{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         title: Text(
//           'Settings',
//           style: TextStyle(
//               color: Colors.white, fontFamily: 'RocgroTesk', fontSize: 24),
//         ),
//         backgroundColor: Color(0xFF145d87),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 20),
//             _buildProfileSection(),
//             SizedBox(height: 40),
//             Text(
//               "Media Auto-upload",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             _buildToggleOption(
//               icon: "images/app/icons/mobiledata.svg",
//               title: "When using mobile data",
//             ),
//             SizedBox(height: 20),
//             _buildToggleOption(
//               icon: "images/app/icons/wifi.svg",
//               title: "When connected on Wi-Fi",
//             ),
//             SizedBox(height: 40),
//             _buildLogoutButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileSection() {
//     return Row(
//       children: <Widget>[
//         CircleAvatar(
//           radius: 40,
//           backgroundImage: AssetImage("images/app/icons/user.png"),
//         ),
//         SizedBox(width: 20),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'username',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 4),
//             Text(
//               "mounica@example.com",
//               style: TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildToggleOption({required String icon, required String title}) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//       ),
//       child: Row(
//         children: <Widget>[
//           SvgPicture.asset(
//             icon,
//             width: 40,
//             height: 40,
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(color: Colors.black, fontSize: 16),
//             ),
//           ),
//           ToggleSwitch(
//             minWidth: 50,
//             initialLabelIndex: 1,
//             cornerRadius: 20,
//             activeBgColor: [Color(0xFF145d87)],
//             activeFgColor: Colors.white,
//             inactiveBgColor: Colors.grey,
//             inactiveFgColor: Colors.white,
//             labels: ['Yes', 'No'],
//             onToggle: (index) {
//               print('switched to: $index');
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLogoutButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CompanyName(),
//             ),
//           );
//           // Show toast message
//           Fluttertoast.showToast(
//             msg: "Logged out successfully",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF145d87),
//           padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: Text(
//           "Logout",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }
