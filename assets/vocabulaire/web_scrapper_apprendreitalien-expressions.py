import requests
from bs4 import BeautifulSoup
import json
import time
import pathlib

def get_page_content(url):
    """Récupère le contenu HTML d'une page."""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }
    response = requests.get(url, headers=headers, timeout=10)
    response.raise_for_status()
    return response.text

def parse_expressions_cards(expression_cards, difficulty:str, category:list[str] = ["Expressions"]):
    """Parse les cartes d'expressions et extrait les informations."""
    expressions = []

    for card in expression_cards:
        # Extraire l'expression en italien (ex: dans un <h3> ou <p>)
        it_expression_tag = card.find('h3', class_="font-semibold text-gray-900 group-hover:text-green-700 transition-colors text-lg")
        it_expression = it_expression_tag.get_text(strip=True) if it_expression_tag else None

        # Extraire la traduction en français (ex: dans un <p> suivant)
        fr_translation_tag = card.find('span', class_="shrink-0 text-green-600 text-sm font-medium mt-1")
        fr_translation = fr_translation_tag.get_text(strip=True) if fr_translation_tag else None

        
        if it_expression and fr_translation:
            expressions.append({
                "it": it_expression,
                "fr": fr_translation,
                "categories": category,
                "difficulty": difficulty,
                "partOfSpeech": "Expression",
            })

    return expressions

    
    

def find_expressions_cards_page(url, LIMIT=None):
    """Parse la page des expressions idiomatiques et extrait les informations."""
    expressions = []
    try:
        html = get_page_content(url)
        soup = BeautifulSoup(html, 'html.parser')
        
        # Extraire la catégorie (ex: "Animali")
        category_tag = soup.find('h1', class_="text-2xl md:text-3xl font-bold text-gray-900")
        category = [category_tag.get_text(strip=True).split("—")[1].strip()] if category_tag else None

        difficulty_links = soup.find('div', class_="max-w-3xl mx-auto px-4 py-2 flex gap-2 overflow-x-auto").find_all('a', href=lambda x: x and x.startswith('#'))
        for link in difficulty_links:
            # Extraire le niveau de difficulté (ex: "A2")
            difficulty = link.get_text(strip=True).split('(')[0]  # Prend "A2" dans "A2 (56)"
            difficulty_div = soup.find('div', id=difficulty.lower())
            if not difficulty_div:
                continue  # Passer si la div n'existe pas
            
            # Récupérer toutes les cartes d'expressions dans cette div
            expression_cards = difficulty_div.find_all('a', class_='block border border-gray-200 rounded-xl p-5 hover:border-green-400 hover:shadow-sm transition-all group')
            parsed_expressions = parse_expressions_cards(expression_cards, difficulty, category)
            if parsed_expressions:
                expressions.extend(parsed_expressions)
            if LIMIT and len(expressions) >= LIMIT:
                print(f"Limite de {LIMIT} expressions atteinte.")
                break
        return expressions[:LIMIT]  # Retourner seulement jusqu'à la limite

    except Exception as e:
        print(f"Erreur lors du parsing de {url}: {e}")
        return None

        

def scrape_expressions_theme(url, LIMIT=None):
    """Scrape les expressions depuis une URL donnée."""
    print(f"Récupération des expressions depuis {url}...")
    expressions = find_expressions_cards_page(url, LIMIT=LIMIT)

    if expressions:
        print(f"Trouvé {len(expressions)} expressions.")
        return expressions
    else:
        print("Aucune expression trouvée.")
        return []


def scrape_themes(base_url, LIMIT=None):
    """Scrape les thèmes d'expressions depuis la page principale."""
    try:
        html = get_page_content(base_url)
        soup = BeautifulSoup(html, 'html.parser')

        # Trouver tous les liens vers les thèmes d'expressions
        theme_links = soup.find_all('a', class_="flex items-center gap-3 mb-2")
        all_expressions = []

        for link in theme_links:
            theme_url = link.get('href')
            if not theme_url.startswith("http"):
                theme_url = base_url.rstrip('/') + '/' + theme_url.lstrip('/').split('/')[1]  # Construire l'URL complète
            print(f"Scraping le thème: {theme_url}")
            expressions = scrape_expressions_theme(theme_url, LIMIT=LIMIT)
            all_expressions.extend(expressions)
            if LIMIT and len(all_expressions) >= LIMIT:
                print(f"Limite de {LIMIT} expressions atteinte.")
                break

        return all_expressions[:LIMIT]  # Retourner seulement jusqu'à la limite

    except Exception as e:
        print(f"Erreur lors du scraping des thèmes depuis {base_url}: {e}")
        return []

def main():
    # URL de la page des expressions idiomatiques
    expressions_url = "https://apprendreitalien.com/expressions-idiomatiques/"

    # Scraper les expressions
    expressions = scrape_themes(expressions_url)

    # Sauvegarder dans un fichier JSON
    output_path = pathlib.Path(__file__).parent / 'expressions_apprendreitalien-expressions.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(expressions, f, indent=2, ensure_ascii=False)

    print(f"\n{len(expressions)} expressions sauvegardées dans {output_path}")

    # Afficher un exemple
    if expressions:
        print("\nDébut des expressions extraites :")
        print(json.dumps(expressions[:2], indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()