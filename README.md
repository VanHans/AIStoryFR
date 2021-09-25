# AIStoryFR

AIStoryFR est une fiction interactive textuel piloté par une IA
inspirée du célèbre jeu [AI Dungeon](https://play.aidungeon.io/main/home).
AIStoryFR utilise un réseau de [neurones artificiels](https://en.wikipedia.org/wiki/Artificial_neural_network) pour générer du texte cohérent et donner suite à vos actions.

## Pourquoi AIStoryFR?

AIStoryFR utilise un modèle GPT spécifiquement pré-entrainé sur la langue française pour générer un langage naturel ([NLP](https://en.wikipedia.org/wiki/Artificial_neural_network)).
Là où AI Dungon est entrainé sur la langue Anglosaxonne.

AIStoryFR n'est pas une copie de AI Dungeon.

La mécanique de jeu est différente, vous n'avez pas besoin de spécifier si vous faite une action ou dites
quelque-chose.
Vous vous contentez d'écrire une partie de votre histoire et l'IA vous écrit la suite.

## Le modèle GPT

Le modèle recommandé pour AIStoryFR est un modèle de structure [GPT-2](https://openai.com/blog/better-language-models/) développé par [OpenAI](https://openai.com/blog/better-language-models/), pré-entrainé par [Quantmetry](https://www.quantmetry.com/) et le [Laboratoire de Linguistique Formelle (LLF)](http://www.llf.cnrs.fr/). 
Le corpus de base de l'entrainement sont: 

* [Wikipédia](https://fr.wikipedia.org/wiki/Wikip%C3%A9dia:Accueil_principal)
* [OpenSubtitle](https://www.opensubtitles.org/)
* [Projet Gutenberg](https://www.gutenberg.org/browse/languages/fr) 

Documentation:
* https://huggingface.co/datasets/asi/wikitext_fr

# Installation

### Requirements: ###

* **[Windows 10](https://www.microsoft.com/fr-fr/software-download/windows10)**

Il est recommandé d'avoir Windows terminal installé sur son PC (Optionnel).
* https://aka.ms/terminal

AIStoryFR utilise [PyTorch](https://pytorch.org/) ([Torch](http://torch.ch/)) soit en mode CPU (processeur) ou GPU (carte graphique)
Il est donc vivement conseillé d'avoir soit:

* Un processeur (**I5 Gen 8**) -- recommandé

**OU**

* Une carte graphique **NVIDIA** 8Go VRAM -- recommandé

### Comment installer? ###

**Il est conseillé de désactiver votre antivirus pour l'installation**

De manière générale les antivirus bloquent les téléchargements de dépendances via les fichiers .bat

* **Téléchargez l'archive .zip dans la section "<> Code" dans l'onglet "code" du projet GitHub.**
* **Dézippez l'archive sur votre ordinateur.**
* **Lancez "Installation.bat" dans le dossier du jeu.**
* **Suivez les étapes.**
* **Une fois l'installation terminé vous pouvez jouer en cliquant sur "AIStoryFR.bat".**

### Comment jouer? ###

AIStoryFR contrairement à AI Dungeon ne garde pas en mémoire le contexte. C'est un choix.
Il serait facile de faire en sorte de garder un contexte en mémoire sous la forme d'un "prompt" cependant
cela serait extrêmement gourmand en ressources CPU ou GPU.

Donc, pour jouer il est conseillé à chaque fois que l'ont écrit de préciser un contexte et une action par exemple:

"Je suis chez moi il est tard, je n'arrive pas à dormir, je décide de jouer à AIStoryFR"

"Je suis chez moi il est tard, je n'arrive pas à dormir" <-- Contexte

"je décide de jouer à AIStoryFR" <-- Action

### Avertissement ###

* **Le modèle utilisé peux générer du langage violent, sexuel, obscène ou vulgaire.
AIStoryFR ne convient pas aux mineurs.**

# FAQ

#### Puis-je installer AIStoryFR sur Windows 7? ####

* Oui et Non, AIStoryFR est développé sous [Python 3.9](https://www.python.org/downloads/release/python-390/) et celui ci [ne supporte plus Windows 7](https://www.python.org/downloads/release/python-390/). Cependant il est possible d'ajouter la dll manquante à Windows mais celle-ci présente une [faille de sécurité sur Windows 7](https://vigilance.fr/vulnerability/Python-executing-DLL-code-via-Windows-7-api-ms-win-core-path-l1-1-0-dll-31456). Donc je ne vous conseille pas de l'installer sur cette version de Windows.

### Auteur ###

* Developpeur: PENEAUX Benjamin
