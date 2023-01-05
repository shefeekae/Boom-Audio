import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:music_app/functions/reset_app.dart';
import 'package:music_app/screens/currently_playing.dart';
import 'package:music_app/widgets/mini_player.dart';
import 'package:music_app/widgets/share_link.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../functions/get_songs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.grey[300],
          title: const Text(
            'Settings',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: playingSongNotifier,
          builder: (context, List<SongModel> music, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (GetSongs.player.currentIndex != null)
                ValueListenableBuilder(
                    valueListenable: playingSongNotifier,
                    builder: (BuildContext context, playingSong, child) {
                      return Miniplayer(
                        minHeight: 60,
                        maxHeight: 60,
                        builder: (height, percentage) {
                          return MiniPlayerWidget(
                            miniPlayerSong: playingSong,
                          );
                        },
                      );
                    })
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              ListTile(
                title: const Text(
                  'App Settings',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                onTap: () {
                  openAppSettings();
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  // const LicensePage(
                  //   applicationName: 'Boom Audio',
                  //   applicationVersion: '1.0.0',
                  // );
                  showAboutDialog(
                      context: context,
                      applicationName: 'Boom Audio',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© Boom Audio 2022');
                },
                title: const Text(
                  'About Us',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[300],
                      title: const Text('Reset App'),
                      content: const Text(
                        'Are you sure ?',
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () {
                              ResetApp.appReset(context);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            )),
                      ],
                    ),
                  );
                },
                title: const Text(
                  'Reset App',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text('Mail us at shafemohd000@gmail.com'),
                    ),
                  );
                },
                title: const Text(
                  'Feedback',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  shareLink(context);
                },
                title: const Text('Share',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text('Privacy Policy'),
                        content: SingleChildScrollView(
                          child: Text("""
                        Mohammed Shefeek A built the BOOM AUDIO app as a Free app. This SERVICE is provided by Mohammed Shefeek A at no cost and is intended for use as is.
                        
                        This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.
                        
                        If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.
                        
                        The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at BOOM AUDIO unless otherwise defined in this Privacy Policy.
                        
                        Information Collection and Use
                        
                        For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way.
                        
                        The app does use third-party services that may collect information used to identify you.
                        
                        Link to the privacy policy of third-party service providers used by the app
                        
                        Google Play Services
                        Log Data
                        
                        I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.
                        
                        Cookies
                        
                        Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.
                        
                        This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.
                        
                        Service Providers
                        
                        I may employ third-party companies and individuals due to the following reasons:
                        
                        To facilitate our Service;
                        To provide the Service on our behalf;
                        To perform Service-related services; or
                        To assist us in analyzing how our Service is used.
                        I want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.
                        
                        Security
                        
                        I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.
                        
                        Links to Other Sites
                        
                        This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.
                        
                        Children’s Privacy
                        
                        These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions.
                        
                        Changes to This Privacy Policy
                        
                        I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.
                        
                        This policy is effective as of 2023-01-02
                        
                        Contact Us
                        
                        If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at shafemohd000@gmail.com.
                        
                        This privacy policy page was created at privacypolicytemplate.net and modified/generated by App Privacy Policy Generator"""),
                        ),
                      );
                    },
                  );
                },
                title: const Text('Privacy Policy',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
              const SizedBox(
                height: 300,
              ),
              const Text(
                'Version 1.0.1',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}
