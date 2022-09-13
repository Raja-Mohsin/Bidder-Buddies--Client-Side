import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class TermsAndPolicyScreen extends StatelessWidget {
  const TermsAndPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text('Terms and Policies'),
      ),
      drawer: UserDrawer('user'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              buildHeading('ACCEPTANCE', '1'),
              buildParagraph(
                  'The Application and the Service are provided to you subject to these Bidder Buddies Terms of Use (these "Terms"). For the purpose of the Terms and wherever the context so requires, the terms \'you\' and your shall mean any person who uses the Application or the Service in any manner whatsoever including persons browsing the Application and its content, posting comments or any content or responding to any advertisements or content on the Application. By accessing, browsing or using the Application or Service, you agree to comply with these Terms. Additionally, when using a portion of the Service, you agree to conform to any applicable posted guidelines for such Service, which may change or be updated from time to time at Bidder Buddies sole discretion.'),
              //
              buildHeading('DESCRIPTION OF SERVICE', '2'),
              buildParagraph(
                  'Bidder Buddies is the next generation of free online classifieds. We act as an online marketplace platform to allow our users who comply with these Terms to offer, sell, and buy products and services listed on the Application. Although you may be able to conduct payment and other transactions through the Application, using third-party vendors such as Easypaisa & JazzCash, Bidder Buddies is not in any way involved in such transactions. As a result, and as discussed in more detail in these Terms, you hereby acknowledge and agree that Bidder Buddies is not a party to such transactions, has no control over any element of such transactions, and shall have no liability to any party in connection with such transactions. You use the Service and the Application at your own risk.'),
              //
              buildHeading('FEATURED ADS', '3'),
              buildParagraph(
                  'Bidder Buddies may offer a service known as "Featured Ads" where users may pay a non-refundable fee to have their ads posted in selected locations on the Application, thus potentially increasing an ads\' visibility. In order to purchase a Featured Ad, you may be required to transmit certain information through a third party service provider, which may be governed by its own terms of use and other policies. Bidder Buddies makes no representation or guarantee as to the safety or security of the information transmitted to any Third Party service provider, and your linking to any Third Party service is completely at your own risk, and Bidder Buddies disclaims all liability related thereto.'),
              //
              buildHeading('CONDUCT', '4'),
              buildParagraph(
                  'You agree not to post, email, host, display, upload, modify, publish, transmit, update or share any information on the Site, or otherwise make available Content that violates any law or regulation; that is copyrighted or patented, protected by trade secret or trademark, or otherwise subject to third party other intellectual property or proprietary rights, including privacy and publicity rights, unless you are the owner of such rights or have permission or a license from their rightful owner to post the material and to grant Bidder Buddies all of the license rights granted herein; that infringes any of the foregoing intellectual property rights of any party, or is Content that you do not have a right to make available under any law, regulation, contractual or fiduciary relationship(s); that is harmful, abusive, unlawful, threatening, harassing, blasphemous, defamatory, obscene, pornographic, pedophilic, libelous, invasive of another\'s privacy or other rights, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or illegal gambling or harms or could harm minors in any way or otherwise unlawful in any manner whatsoever;'),
              //
              buildHeading('USER SUBMISSIONS', '5'),
              buildParagraph(
                  'You understand that when using the Application, you will be exposed to Content from a variety of sources, and that Bidder Buddies is not responsible for the accuracy, usefulness, safety, or intellectual property rights of or relating to such Content, and you agree and assume all liability for your use. You further understand and acknowledge that you may be exposed to Content that is inaccurate, offensive, indecent, or objectionable, defamatory or libelous and you agree to waive, and hereby do waive, any legal or equitable rights or remedies you have or may have against Bidder Buddies with respect thereto.'),
              //
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeading(String text, String sNo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '$sNo. $text',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Text(
        text,
        style: TextStyle(),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
