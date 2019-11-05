# THP - Week 6 - Project 1 - Eventbrite : introduction et backend
# Francois THIOUNN 

# Notes & Use :

- hosted on heroku at : https://shrouded-dawn-29894.herokuapp.com/
-
-

# Projet : Eventbrite : Devise et premières views
  
1. Introduction
Dans ce projet, tu vas reprendre le projet de la veille pour y construire tes premières vues. Tu vas installer Devise sur ton application et construire les premières vues.

Plus en détails, voici ce que nous attendons de toi :

Tu dois installer Devise sur l'application, et brancher le model User à Devise
Tu vas brancher Bootstrap à ton application
Tu vas faire un header qui comprend les liens importants de ton application, puis le mettre pour toutes les vues de ton application
Tu vas faire la page d'accueil du site
Tu vas faire la page profil d'un utilisateur
Tu vas faire la page de création d'événement
Tu vas faire la page qui affiche un événement
Cela peut paraître flou, mais avec le REST, quelques méthodes de controllers, et un branchement Devise, ton application sera faite bien plus rapidement que la semaine qu'il t'a fallu pour l'application Gossip Project (alors que les deux applications sont très similaires). Ceci est dû principalement au fait que tu commences à gérer la fougère. Bravo ;)

2. Le projet
Avant de commencer, nous allons faire la première vue de l'application : la page d'accueil. Cette page d'accueil est la liste des événements de ta ville, donc l'index des événements. Génère un events_controller, avec la méthode index. Branche cette méthode index à la page d'accueil du site.

2.1. Branchement de Bootstrap
Bootstrap te permettra d'avoir une navbar qui te permet de naviguer dans l'application. Cette navbar contiendra les liens suivants :

Lien pour accéder à l'accueil du site (et donc la liste des événements)
Lien pour créer un événement (events#new)
Liens de profil :
Si le visiteur n'est pas connecté, un dropdown "S'inscrire / Se connecter" avec deux liens :
"S'inscrire", qui correspond à l'inscription d'un utilisateur (registrations#new).
"Se connecter", qui correspond à une connexion d'utilisateur (sessions#new).
Si l'utilisateur est connecté, un dropdown "Mon profil" avec deux liens :
"Mon profil", qui est la page qui affiche le profil de l'utilisateur (users#show).
"Se déconnecter", qui correspond à un logout (sessions#destroy).
Fais donc cette navbar. Comme les routes de ces liens ne sont pas encore définies, mets # aux urls des liens. On les implémentera au fur et à mesure.

2.2. Branchement de Devise
Passons aux choses sérieuses. Nous allons passer par Devise pour toute l'authentification de ton application. Installe Devise et branche-la au model User comme vu dans le cours :

⚠️ ALERTE ERREUR COMMUNE
En temps normal, on créé le model user en même temps que le branchement Devise. Cependant, si l'on tavait demandé hier de faire la base de données ET brancher les emails ET brancher Devise, ton pauvre cerveau aurait déclaré forfait 😵

On va donc t'aider pour cette migration un peu rocambolesque. Ne t'en fais pas, ça va bien se passer et rien ne te pêtera à la gueule. Grosso modo, on va juste changer le fichier de migration.

Installe Devise comme prévu, puis génère le devise user via $ rails g devise user. Cela va créer un fichier de migration, qui n'est pas bon. En effet, comme Devise est ajouté sur un model déjà existant, la gem ne sait pas trop comment gérer cette migration donc il y aura quelques éléments à changer. Ce sera l'occasion de réviser en douceur les migrations avec ce petit pas à pas. Super non ?

Encore une fois, en général on créé le model via son ajout avec Devise ; mais comme il y avait beaucoup d'informations à gérer hier, on a pensé à ta santé mentale et à ton cerveau.

Déjà, Devise avait compris que ton model User existe déjà : le fichier de migration ne fait plus create_table, mais change_table (si l'on compare avec celui donné dans la ressource). Malin. L'autre changement majeur par rapport à la ressource est qu'il ne fait plus def change, mais def self.up et def self.down. En gros Devise te laisse plus de choix dans ce que tu veux faire. Sympa, mais on s'en bat un peu les couilles pour le moment.

Maintenant, si tu regardes le self.down, tu devrais voir les lignes suivantes :

def self.down
  # By default, we don't want to make any assumption about how to roll back a migration when your
  # model already existed. Please edit below which fields you would like to remove in this migration.
  raise ActiveRecord::IrreversibleMigration
end
En gros, Devise te dit "on ne sait pas trop comment tu as géré ton model user jusqu'à présent, donc la seule ligne que l'on va mettre est raise ActiveRecord::IrreversibleMigration". Cette ligne va balancer une erreur et tu devras changer à la main le self.down pour faire marcher le rollback. Pour résumer, tu peux faire des migrations vers up, mais vers down il va te balancer une erreur. On va rectifier cela.

Enfin, avec un peu d'attention, tu peux remarquer que le fichier de migration va créer une colonne pour les emails et une colonne pour les encrypted_passord. Comme tu l'as déjà fait hier, pas besoin de les ajouter. D'ailleurs si tu fais ta migration, cela plantera en te disant que les colonnes emails et encrypted_password existent déjà.

Pour résumer, voici ce qu'il faut faire pour faire marcher ton fichier de migration :

remplace def self.up par def change
vire toutes les lignes qui concernent def self.down (le def.self.down ainsi que le end, ainsi que ce qui est à l'intérieur)
vire les lignes qui ajoutent une colonne email et une colonne encrypted_password
Voilou ! Tu pourras faire des migrations, des rollbacks, utiliser Devise comme un chef, faire la samba, et siroter un thé pendant que tes cookies seront cuisinés par cette gem qui fait le café (cette blague est drôle parce que en fait j'ai utilisé thé et café dans la même phrase. trolol).

Une fois que Devise est branchée, je veux que tu génères les views de Devise :

app/views/devise/registrations/new.html.erb : inscription au site : accessible depuis la navbar
app/views/devise/sessions/new.html.erb : connexion au site : accessible depuis la navbar
app/views/devise/passwords/new.html.erb : l'écran "mot de passe oublié ?" où tu rentres ton adresse email pour recevoir un email de réinitialisation de mot de passe : accessible grâce à la partial shared_links
app/views/devise/registrations/edit.html.erb : l"écran pour modifier son email et son mot de passe : accessible depuis la page profil.
app/views/devise/passwords/edit.html.erb : la vue où tu rentres ton nouveau mot de passe (tu y accèdes en cliquant dans le lien "réinitialiser le mot de passe" dans ton email de réinitialisation de mot de passe) : accessible depuis l'email de demande de changement de mot de passe.
Nous te laissons ajouter les liens d'inscription et de connexion à la navbar, puis de faire en sorte que toutes les views affichent bien la navbar.

Enfin, pour que Devise fonctionne correctement, il te faut faire le branchement du mailer. Rien de plus frustrant de faire une demande de réinitialisation de mot de passe et de ne jamais recevoir son mot de passe. Fais donc les modifications nécessaires pour que Devise envoie bien les emails de récupération.

Une fois que tu as fait cela, pousse le tout sur Heroku et assure toi que ça marche aussi bien que sur ton ordi !

Et là, tu réalises que tu viens de réaliser un système complet d'authentification d'utilisateurs, fonctionnel et en production. C'est une excellente étape vers un site fonctionnel et tu peux être fier de toi.

2.3. Faire les premières views
Avant de passer à cette partie, assure toi que l'ensemble des fonctionnalités demandées ci-dessus fonctionne au poil : c'est le minimum pour valider le projet.

Dans cette partie, nous allons construire les premières views pour que l'application commence à marcher. C'est un processus long donc tu n'arriveras probablement pas à tout faire :

La page d'accueil du site (events#index)
La page profil d'un utilisateur (users#show) => Essaye de finir cette view
La page de création d'un événement (events#new) => Super si tu arrives jusqu'ici
La page d'affichage d'un événement (events#show) => Pour les plus déterminés
Tu peux commencer à générer les controllers, leurs méthodes, et écrire les routes pour ces premières views. Bien entendu, il est interdit d'utiliser les routes en GET/POST et tu devras utiliser resources.

2.3.1. La page d'accueil
La page d'accueil du site affiche tous les événements de l'application. Pour chaque événement, tu pourras cliquer sur un lien qui t'emmènera vers la page show de l'événement. La page d'accueil invitera l'utilisateur à créer son événement.

Pour le front, on est comme d'habitude fans des exemples de Bootstrap. La page jumbotron par exemple a l'air de bien correspondre à ce que l'on veut en page d'accueil.

Bien sûr assure toi que ton seed génère quelques Event afin de donner un peu de contenu à cette page d'accueil.

2.3.2. La page profil d'un utilisateur
La page profil d'un utilisateur devra afficher les informations de l'utilisateur : prénom, nom, description, e-mail (la plupart de ces informations ne sont pas encore renseignées par l'utilisateur, mais le but de cette page est de vous faire faire ce qui va suivre).

La page de profil d'un utilisateur va afficher les événements qu'il a créés (un title et un lien pour chaque Event dont il est administrateur).

Ensuite, la page de profil d'un utilisateur ne doit pas être accessible par ces deux types de personnes :

Les visiteurs non connectés (authenticate_user!)
Les utilisateurs connectés, mais qui ne sont pas sur la page de leur profil (user 23 n'a pas le droit d'aller sur la page profil de user 36). Pour ceci, il te faudra coder une méthode spécifique et t'assure qu'elle est appelée avant (ou au début) de la méthode users#show
En gros, la page profil ne doit être accessible que par la personne concernée. La page de profil doit aussi insérer un lien pour l'édition de l'email et du mot de passe informations importantes (registrations#edit). Les autres informations (la description, le prénom, le nom) ne seront pas éditables.

BONUS pour ceux qui sont en GODMODE : vous pouvez ajouter un lien pour éditer les informations de profil (users#edit) : la description, le prénom, le nom.

2.3.3. Création d'un événement
À partir de la navbar (et de la page d'accueil), il est possible de créer un événement. La création d'événement demandera :

Sa start_date
Sa duration
Son title
Sa description
Son price
Sa location (un input normal suffira)
Nous t'invitons à regarder la page des formulaires de Bootstrap pour t'inspirer sur les visuels que tu peux utiliser.

Quand un événement est créé, le current_user doit y être associé en tant qu'administrateur. Cela veut dire que Devise devra authentifier l'utilisateur avant de pouvoir faire new ou create. Une fois l'événement créé, l'utilisateur sera redirigé vers la page show de l'événement.

2.3.4. Afficher un événement
C'est long de tout implémenter non ? Si tu es arrivé jusqu'ici, BRAVO ! Maintenant tu vas afficher un événement. Cette page devra montrer :

Le titre de l'événement
Sa description complète
Le nombre d'inscrits à l'événement
Le créateur (son email suffira)
Sa date de début, et sa date de fin (la date de fin est une méthode d'instance)
Le lieu de l'événement
Son prix
Demain nous verrons la page pour s'inscrire à l'événement en tant que participant.

3. Rendu attendu
Un repo GitHub accueillant l'app Rails avec un maximum des fonctionnalités ci-dessus. Le tout doit être disponible sur Heroku (lien dans le README).

Avec ceci, tu as une belle application où les gens peuvent voir la liste des événements disponibles dans leur ville. C'est un excellent début et tu peux être fier de toi.

Demain nous allons ajouter les fonctionnalités pour rejoindre un événement et ton application sera prête et fonctionnelle pour être montrée à la Terre entière. À partir de jeudi on implémentera des fonctionnalités pas indispensables, mais qui vont agrémenter l'expérience utilisateur (gestion des images, interface administrateur).