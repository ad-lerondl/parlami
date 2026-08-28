import requests
from bs4 import BeautifulSoup
import json
import re
import time
import pathlib

def get_page_content(url):
    """Récupère le contenu HTML d'une page"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }
    response = requests.get(url, headers=headers, timeout=10)
    response.raise_for_status()
    return response.text

def get_all_word_urls():
    """Récupère tous les liens vers les fiches de mots depuis la page index A-Z"""
    index_url = "https://apprendreitalien.com/vocabulaire/index-az"
    html = get_page_content(index_url)
    soup = BeautifulSoup(html, 'html.parser')
    
    word_urls = []
    # Les liens vers les mots sont dans des balises <a> avec un pattern spécifique
    for link in soup.find_all('a', href=True):
        href = link['href']
        if '/vocabulaire/' in href and href != index_url:
            # Construire l'URL complète si nécessaire
            if href.startswith('/'):
                href = "https://apprendreitalien.com" + href
            word_urls.append(href)
    
    return list(set(word_urls))  # Supprimer les doublons

def parse_word_page(url):
    """Parse une page de mot et extrait les informations disponibles."""
    try:
        html = get_page_content(url)
        soup = BeautifulSoup(html, 'html.parser')

        # Extraction du niveau (ex: A2)
        level_tag = soup.find('span', class_=lambda x: "text-xs font-bold rounded px-2 py-1" in x if x else False)
        level = level_tag.get_text(strip=True) if level_tag else None

        # Extraction du type de mot (ex: verb, noun, etc.)
        genre_tag = soup.find('span', class_="text-xs text-gray-500 border rounded px-2 py-1 capitalize")
        genre = genre_tag.get_text(strip=True) if genre_tag else None

        # Extraction du mot italien (dans h1)
        it_word_tag = soup.find('h1', class_="text-4xl font-bold text-gray-900 mb-1")
        it_word = it_word_tag.get_text(strip=True) if it_word_tag else None

        # Extraction de la traduction française (dans p avec classe text-2xl)
        fr_translation_tag = soup.find('p', class_="text-2xl text-gray-600 mb-4")
        fr_translation = fr_translation_tag.get_text(strip=True) if fr_translation_tag else None

        # Extraction de la catégorie depuis l'URL
        categories = []
        cat_tags = soup.find("h2", class_="text-xl font-bold text-gray-900 mb-4")
        cat = cat_tags.get_text(strip=True).replace("Autres mots :", "").strip() if cat_tags else None
        if cat:
            categories.append(cat)

        # Construction de l'entrée JSON
        if not it_word:
            print(f"Mot italien introuvable pour l'URL: {url}")
            return None
        if genre == "noun" and it_word is not None and it_word.split(" ")[0] is not None:
            article = it_word.split(" ")[0]
            it_word = it_word.replace(article + " ", "")
        else:
            article = None
        word_entry = {
            "it": it_word,
            "fr": fr_translation if fr_translation else "?",
            "categories": categories if categories else ["inconnu"],
            "difficulty": level if level else "-",
            "partOfSpeech": genre if genre else "?"
        }
        if article:
            word_entry["article"] = article

        return word_entry

    except Exception as e:
        print(f"Erreur lors du parsing de {url}: {e}")
        return None

def scrape_all_words(max_words=None):
    """Scrape tous les mots et les retourne au format JSON"""
    print("Récupération de la liste des mots...")
    word_urls = get_all_word_urls()
    print(f"Trouvé {len(word_urls)} URLs de mots")
    
    if max_words:
        word_urls = word_urls[:max_words]
    
    all_words = []
    
    for i, url in enumerate(word_urls):
        try:
            print(f"Progression: {i+1}/{len(word_urls)} - {url}")
            word_entry = parse_word_page(url)
            if word_entry and word_entry["it"]:
                all_words.append(word_entry)
            
            # Pause pour éviter de surcharger le serveur
            time.sleep(0.5)
            
        except Exception as e:
            print(f"Erreur: {e}")
            continue
    
    return all_words

def main():
    # Scrape tous les mots
    words = scrape_all_words()  # En production, on ne limite plus les résultats
    
    # Formatage en JSON
    json_output = json.dumps(words, indent=2, ensure_ascii=False)
    
    # Sauvegarder dans un fichier
    with open(pathlib.Path(__file__).parent / 'vocab_apprendreitalien-vocabulaire.json', 'w', encoding='utf-8') as f:
        f.write(json_output)
    
    print(f"\n{len(words)} mots sauvegardés dans {pathlib.Path(__file__).parent / 'vocab_apprendreitalien-vocabulaire.json'}")
    
    # Afficher un exemple
    if words:
        print("\nDébut du fichier :")
        print(json.dumps(words[:2], indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()