from transformers import GPT2Tokenizer, GPT2LMHeadModel
from colorama import Fore, Back, Style
from os import system
import torch
import textwrap as tr
import textwrap
import os.path
import configparser
import sys

def pause():

    input("Appuyez sur ENTREE pour continuer.")
    
def exit_p():

    input("Appuyez sur ENTREE pour quitter.")
    sys.exit()

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print('Using device:', device)
print()


#draw init image
fichier = open("images\init.txt", "r")
print(Fore.GREEN + fichier.read())
fichier.close()
print()

def check_model():

    #chek models available in models dir
    listmodels = os.listdir('models')

    if len(listmodels) == 0:

        print("Vous n'avez pas de modèle installé.")
        exit_p()

    elif len(listmodels) == 1:

        choice_model = 0
        
        used_model = listmodels[int(choice_model)]

        return used_model

    elif len(listmodels) > 1:

        print(Fore.MAGENTA + "Choisissez un modèle: " + Fore.WHITE)
        print()

        choice_number = 0

        for countmodels in listmodels:     
        
            print("    " + Fore.YELLOW + str(choice_number) + ") " + str(countmodels))
        
            choice_number = choice_number + 1
        
        print()
    
        choice_model = input(Fore.GREEN + "Entrez votre choix: " + Fore.WHITE)
        
        try:
            value = int(choice_model)
            
        except ValueError:
        
            print(Fore.RED + "ERREUR: Veuillez entrer un nombre.")
            pause()
            return check_model()
        
        if bool(choice_model) == False or int(choice_model) > choice_number-1:

            print(Fore.RED + "ERREUR: Le modèle demandé n'est pas valide.")
            
            pause()
            
            return check_model()
            
        else:
     
            used_model = listmodels[int(choice_model)]
            
            return used_model
               
used_model = check_model()

def check_savegame():

    #check savegames
    listsavegames = os.listdir("save")
    
    print()
    print(Fore.MAGENTA + "Choix de l'histoire:")
    print()
    print("    " + Fore.YELLOW + "0) Créer une nouvelle histoire.")
    
    if len(listsavegames) > 0:
    
        print("    " + Fore.YELLOW + "1) Charger une histoire.")
    
    print()
    choice_game = input(Fore.GREEN + "Entrez votre choix: " + Fore.WHITE)
    print()
    
    try:
    
        value = int(choice_game)
            
    except ValueError:
        
        print(Fore.RED + "ERREUR: Veuillez entrer un nombre.")
        pause()
        return check_savegame()
        
    if bool(choice_game) == False or int(choice_game) > 1:
    
        print(Fore.RED + "ERREUR: Le choix est invalide.")
        pause()
        return check_savegame()

    if choice_game == str(0):

        selected_savegame = input(Fore.GREEN + "Nom de la sauvegarde: " + Fore.WHITE)
        print()
        print(Fore.MAGENTA + "Commencement de l'histoire...")
        print()
        
        if len(selected_savegame) < 1:
        
            print(Fore.RED + "ERREUR: Le nom de la sauvegarde n'est pas valide.")
            pause()
            return check_savegame()

    if choice_game == str(1):

        print(Fore.MAGENTA + "Chargement de l'histoire:")
        print()

        if len(listsavegames) == 0:
    
            print()
            print(Fore.RED + "ERREUR: Vous n'avez pas d'histoire sauvegardée.")
            pause()
            return check_savegame()
        
        elif len(listsavegames) > 0:
    
            choice_number = 0

            for countsavegames in listsavegames:     
        
                print("    " + Fore.YELLOW + str(choice_number) + ") " + str(countsavegames))
        
                choice_number = choice_number + 1            

            print()
            choice_savegame = input(Fore.GREEN + "Entrez votre choix: " + Fore.WHITE)
            
            try:
    
                value = int(choice_savegame)
            
            except ValueError:
        
                print(Fore.RED + "ERREUR: Veuillez entrer un nombre.")
                pause()
                return check_savegame()
        
            if bool(choice_savegame) == False or int(choice_savegame) > len(listsavegames)-1:
                print(Fore.RED + "ERREUR: Le choix de la sauvegarde n'est pas valide.")
                return check_savegame()

            name_savegame = listsavegames[int(choice_savegame)]
            selected_savegame = name_savegame.replace(".txt", "")        
        
            print()
            #load and print save file
            print()
            print(Fore.MAGENTA + "Chargement de l'histoire sauvegardée..." + Fore.RESET)
        
            if os.path.isfile("save\\" + selected_savegame + ".txt"):

                fichier = open("save\\" + selected_savegame + ".txt", "r")
            
                #recolor text
                text_colored = fichier.read().replace("[Vous]:",Fore.MAGENTA + "[Vous]:" + Fore.WHITE)
                fichier.close()
                text_colored = text_colored.replace("[Histoire]:",Fore.MAGENTA + "[Histoire]:" + Fore.WHITE)
                #fit text to console
                text_bloc = textwrap.fill(text_colored,width=90,break_long_words=False,replace_whitespace=False)
                text_bloc = tr.indent(text_bloc, "    ", lambda line: True)
            
                print(text_bloc)
               
            else:

                print(Fore.RED + "ERREUR: Aucune sauvegarde trouvé." + Fore.RESET)
                
    return selected_savegame

selected_savegame = check_savegame()

# Load pretrained model and tokenizer
model = GPT2LMHeadModel.from_pretrained("models/" + used_model)
tokenizer = GPT2Tokenizer.from_pretrained("models/" + used_model)
# Generate a sample of text

model.to(device)
model.eval()

def dialog_start():

    print()
    print(Fore.MAGENTA + "    [Vous]:" + Fore.WHITE)
    print()
    input_user = input("    " + Fore.GREEN + ">> " + Fore.WHITE)
    
    if bool(input_user) == False:
    
        print(Fore.RED + "    ERREUR: Veuillez écrire quelque-chose.")
        return dialog_start()
    
    input_sentence = input_user

    input_ids = tokenizer.encode(input_sentence, return_tensors="pt").to(device)

    #model.to(device)

    beam_outputs = model.generate(

        input_ids,
        max_length=100,
        do_sample=True,
        top_k=50,
        top_p=0.95,
        num_return_sequences=1

    ).to(device)
    print()
    print(Fore.MAGENTA + "    [Histoire]:\n" + Fore.WHITE)
    
    result_token = tokenizer.decode(beam_outputs[0], skip_special_tokens=True)
    
    escape_input = result_token.replace(input_user, "...")
    
    out_text = escape_input + "..."
    text_bloc = textwrap.fill(out_text,width=90,break_long_words=False,replace_whitespace=False)
    text_bloc = tr.indent(text_bloc, "    ", lambda line: True)
    print(text_bloc)
    
    #Save Story in save file
    fichier = open("save\\" + selected_savegame + ".txt", "a")
    fichier.write("\n\n[Vous]:\n\n" + input_user)
    fichier.write("\n\n[Histoire]:\n\n" + escape_input)
    fichier.close()

    return dialog_start()

dialog_start()