
import 'package:flutter/material.dart';
import 'package:quranapp/consts/colors.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {

   

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: buttonColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: titleColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: buttonColor,
          ),
          child: const Icon(Icons.join_right, size: 18.0, color: titleColor)) : null,
    );
  }
}
  class ProfileMenuSwitch extends StatefulWidget {
const ProfileMenuSwitch({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  State<ProfileMenuSwitch> createState() => _ProfileMenuSwitchState();
}

class _ProfileMenuSwitchState extends State<ProfileMenuSwitch> {

         
        
            
  bool light = true;


        @override
        Widget build(BuildContext context) {
      return ListTile(
      onTap: (){},
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: buttonColor.withOpacity(0.1),
        ),
        child: Icon(widget.icon, color: titleColor),
      ),
      title: Text(widget.title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: widget.textColor)),
      trailing: widget.endIcon? Container(
          width: 30,
          height: 30,
          
          child: Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: buttonColor,
      focusColor: titleColor,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
         )
      ): null, );
        }
        
      }