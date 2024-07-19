import '../utils/consts.dart';

const String urlPayPal =
    'https://www.paypal.com/donate?hosted_button_id=986PSAHLH6N4L';
const String urlGitHub = 'https://github.com/Webierta/phototook';
const String urlGitHubIssues = 'https://github.com/Webierta/phototook/issues';

class MarkdownAbout {
  static String en1 = """
# PhoToTook

#### META SEARCH ENGINE FOR PHOTOS ON THE BEST IMAGES PLATFORMS

---

**PhotoTook** searches for photos on top image platforms, including Unsplash, Pexels, Flickr, Pixabay and Openverse. In future revisions, these sources may be modified or expanded.

The app accesses photos from the platforms through their API and has no official relationship with any of them.

The app allows you to use some filters to search for photos, such as predominant color and orientation, although not all platforms support filters.

The application presents the images and associated information in different layouts and allows you to save images as favorites.

## Author and License

> Version $version
> Copyleft 2024. Hosted on [Github]($urlGitHub)
> Jesús Cuerda (Webierta)
> All Wrongs Reserved. Licencia GPLv3

This app is freely shared under the terms of the *GNU General Public License v.3* in the hope that it will be useful, but WITHOUT ANY WARRANTY. This program is **free software**: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 (GPLv3). The GNU General Public License does not permit incorporating this program into proprietary programs.

**PhotoTook** is *free and open source software*. Please consider contributing to keep the development of this App active. Thank you.

Any suggestions, criticism, comments or bug reports are appreciated. Do you think you've found a problem? Identifying and fixing bugs makes this app better for everyone. Report a bug at [GitHub issues]($urlGitHubIssues).

You can help the development of this and other apps with a small contribution via PayPal or Bitcoins. Thank you!

Donate via Paypal (opens PayPal payment page):

###### [![paypal](assets/images/paypal.png)]($urlPayPal)

To make a donation in Bitcoins, scan this QR code with your wallet app

###### ![Bitcoin_QR](assets/images/Bitcoin_QR.png)

or copy my BTC wallet address:

""";

  static String en2 = """

---

## Warranty, Security and Privacy

**Free and ad-free application**. No user data is used. **Open source software** (source code on Github), free of spyware, malware, viruses or any process that threatens your device or violates your privacy. This application does not extract or store any information or require any external permission, and renounces advertising and any tracking mechanism.

Each platform has its own terms and conditions and its own privacy and cookie policy, and images have different types of license and property rights for their use.

It cannot be guaranteed that the content offered is free of errors, whether errors in the server from which the data originates, in the process of accessing the data or in its processing, so the information presented does not have any guarantee, either explicit or implicit. The user expressly agrees to be aware of this circumstance. The use of the information obtained by this App is carried out by the user at his own risk and expense, and he is solely responsible to third parties for any damages that may arise from it.

---

## Attributions

### Images:

* Imagen en pantalla de inicio de [Lisa Fotios](https://www.pexels.com/es-es/foto/persona-con-foto-de-un-solo-arbol-durante-el-dia-1252983/) on Pexels.

* GIFs de [David Montero](https://pixabay.com/es/users/editiox-6398285/?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6613) on [Pixabay](https://pixabay.com/es//?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6613).

* GIFs de [David Montero](https://pixabay.com/es/users/editiox-6398285/?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6592) on [Pixabay](https://pixabay.com/es//?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6592).

### Fonts:

* Nunito. Copyright 2014 [The Nunito Project Authors](https://github.com/googlefonts/nunito). Licensed under the SIL Open Font License, Version 1.1.

* Major Mono Display. Copyright 2018 [The Major Mono Project Authors](https://github.com/googlefonts/majormono). Licensed under the SIL Open Font License, Version 1.1.

""";
}
