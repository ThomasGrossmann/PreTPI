# *Documentation Projet PréTPI*
07.02.2022 - Thomas Grossmann - Si-C4a

### *Introduction*
>Projet : Application mobile développée en Flutter (Dart) avec l'IDE Android Studio. <br>Documentation : Documentation détaillée sur les différentes recherches et informations sur les outils utilisés, écrite en Markdown avec l'éditeur de texte **ATOM**.

### *Partie 1 - Recherches Flutter*
>Cette partie va contenir des comparaisons avec les différents concurrents dans le domaine du développement mobile.

#### *Avantages*
- Un seul design pour **Android et iOS**
- Communauté grandissante donc grand support
- Outil fonctionnant également sur ordinateur et navigateur (application PC ou Webapp)

#### *Inconvénients*
- Les applications ont tendance à être lourdes (taille de l'application)
- Malgré sa popularité et sa communauté, les outils et librairies intégrés sont limités

#### *Concurrents*
>Les réels concurrents sont, à mon avis, les autres frameworks/langages multi-plateformes suivants :

- React Native (framework JavaScript)
  - Les avantages et inconvénients sont quasiment similaires à Flutter
  - Basé sur ReactJS, framework Web, donc facilement transposable en Webapp et meilleur si l'on veut faire également du Web
- Xamarin (.NET et C#)
  - 2 façons, Forms Xamarin et Xamarin Native
    - Mêmes interfaces partout, 90-95% du code partageable, pas idéal pour les apps avec beaucoup de data
    - Interfaces différentes partout, 70% du code partageable, recommandé lorsque les interfaces custom sont plus importantes que le partage de code
  - Grâce à .NET, donne accès aux SDKs natifs d'Android et iOS directement.
  - Support technique de Microsoft
- Ionic (AngularJS, Cordova et Node JS, tous frameworks JavaScript)
  - Comme React Native, utilise un bridge pour fonctionner en "natif", ce qui peut affecter les performances
  - Système dépendant énormément des plugins

#### *IDE / Éditeurs*
>Les développeurs de Flutter recommandent l'utilisation d'**Android Studio** ou **IntelliJ** avec installation des plugins Dart et Flutter. D'autres sont concurrents.

- ATOM
  - Pas un "vrai" IDE, besoin d'avoir énormément de plugins et packages en plus
  - Tous les plugins en plus devront être justifiés lors de la défense
- Emacs
  - Comme ATOM, pas un "vrai" IDE, plugins à installer et à défendre plus tard "pour pas grand chose"
- Visual Studio Code
  - J'aurai pu choisir de partir sur VSCode mais le fait de pouvoir simuler le téléphone et voir son application mise à jour en temps réel est vraiment bien,

**ATOM** et **Emacs** ne sont pas de véritables IDE mais de "simples" éditeurs de texte. Je ne vais donc pas en tenir compte et choisir Android Studio. Les fonctionnalités entre les IDE sont relativement similaires et la plupart de temps c'est à choix.

### *Partie 2 - Installation des outils*
>Cette partie va contenir quelques détails sur les outils installés.

#### *GIT*
>Dernière version de GIT installée avec Chocolatey (choco install git).

- Version : 2.35.1.windows.2

#### *Flutter*
>Flutter est un SDK à télécharger depuis le site des développeurs.<br>
https://docs.flutter.dev/get-started/install/windows

- Télécharger le SDK
- Extraire le contenu du .zip (idéalement ailleurs que dans C:\Program Files\)

#### *Android Studio*
>https://developer.android.com/studio

Ce qui est installé de base avec Android Studio :
- Android Emulator
- Android SDK Build-Tools 32
- Android SDK Build-Tools 32.1-rc1
- Android SDK Platform 32
- Android SDK Platform-Tools
- Android SDK Tools
- Intel x86 Emulator Accelerator (HAXM installer)
- SDK Patch Applier v4

Installation du plugin Flutter :
- Dans "Plugins", naviguer et installer "Dart" et "Flutter". Le plugin Flutter ne fonctionne qu'avec le plugin Dart déjà installé

Nouveau projet :
- Dans "Projects", "New Flutter Project"
- Dans "Flutter", entrer le chemin du SDK précédemment extrait
