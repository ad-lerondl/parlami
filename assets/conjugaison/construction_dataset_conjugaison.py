import json
import pathlib
import re
import time
import xml.etree.ElementTree as ET

import requests
from bs4 import BeautifulSoup


# ============================================================================
# CONFIGURATION
# ============================================================================

BASE_DIR = pathlib.Path(__file__).parent

SITEMAP_URL = "https://italianverbs.info/sitemap.xml"
BASE_URL = "https://italianverbs.info/"

OUTPUT_FILE = BASE_DIR / "BDD_conjugaison.json"
URLS_FILE = BASE_DIR / "list_verbs_BDD.txt"

REQUEST_TIMEOUT = 15
REQUEST_DELAY = 0.2

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 "
        "(KHTML, like Gecko) "
        "Chrome/140.0.0.0 Safari/537.36"
    ),
    "Accept": "text/html,application/xhtml+xml",
    "Accept-Language": "fr-FR,fr;q=0.9,en;q=0.8",
}

REVERSO_LANGUAGES = {
    "fr": "french",
    "en": "english",
    "es": "spanish",
    "de": "german",
    "pt": "portuguese",
    "ar": "arabic",
    "ru": "russian",
    "ja": "japanese",
    "he": "hebrew",
    "pl": "polish",
    "ro": "romanian",
    "sv": "swedish",
    "tr": "turkish",
}

SECTION_NAMES = {
    "indicativo": "Indicativo",
    "congiuntivo": "Congiuntivo",
    "condizionale": "Condizionale",
    "imperativo": "Imperativo",
    "infinito": "Infinito",
    "participio": "Participio",
    "gerundio": "Gerundio",
}

IMPERSONAL_SECTIONS = {
    "Infinito",
    "Participio",
    "Gerundio",
}

GROUPS = {
    "premier": 1,
    "deuxième": 2,
    "troisième": 3,
}


# ============================================================================
# OUTILS HTTP
# ============================================================================

def get_page_content(url):
    """Télécharge une page HTML et retourne son contenu."""
    response = requests.get(
        url,
        headers=HEADERS,
        timeout=REQUEST_TIMEOUT,
    )

    response.raise_for_status()

    return response.text


# ============================================================================
# RÉCUPÉRATION DES VERBES
# ============================================================================

def get_available_verbs():
    """Récupère toutes les URLs de verbes depuis le sitemap."""
    print("Récupération de la liste des verbes...")

    response = requests.get(
        SITEMAP_URL,
        headers=HEADERS,
        timeout=REQUEST_TIMEOUT,
    )

    response.raise_for_status()

    root = ET.fromstring(response.content)

    namespace = {
        "sitemap": "http://www.sitemaps.org/schemas/sitemap/0.9"
    }

    verb_urls = []

    for url_element in root.findall("sitemap:url", namespace):
        loc = url_element.find("sitemap:loc", namespace)

        if loc is None or not loc.text:
            continue

        url = loc.text.rstrip("/")
        verb = url.split("/")[-1]

        if verb:
            verb_urls.append(f"{BASE_URL}{verb}")

    verb_urls = sorted(set(verb_urls))

    print(f"{len(verb_urls)} verbes trouvés")

    URLS_FILE.write_text(
        "\n".join(verb_urls),
        encoding="utf-8",
    )

    return verb_urls


# ============================================================================
# PARSING D'UNE PAGE DE VERBE
# ============================================================================

def parse_verb_page(url):
    """
    Parse une page italianverbs.info et extrait :
    - l'infinitif
    - la traduction française
    - le groupe
    - la régularité
    - le caractère pronominal
    - l'auxiliaire
    - les conjugaisons
    """

    try:
        html = get_page_content(url)
        soup = BeautifulSoup(html, "html.parser")

        # --------------------------------------------------------------------
        # Infinitif
        # --------------------------------------------------------------------

        infinitive = extract_infinitive(soup)

        if not infinitive:
            print(f"Infinitif introuvable : {url}")
            return None

        result = {
            "infinitive": infinitive,
            "conjugations": {},
        }

        # --------------------------------------------------------------------
        # Traduction française
        # --------------------------------------------------------------------

        result = add_translations_ilconiugatore(result)

        if result is None:
            return None

        # --------------------------------------------------------------------
        # Groupe / régularité / pronominal / auxiliaire
        # --------------------------------------------------------------------

        result = add_group_and_regularity(result)

        if result is None:
            return None

        # --------------------------------------------------------------------
        # Conjugaisons
        # --------------------------------------------------------------------

        extract_conjugations(soup, result)

        return result

    except requests.RequestException as error:
        print(f"Erreur HTTP pour {url} : {error}")
        return None

    except Exception as error:
        print(f"Erreur lors du parsing de {url} : {error}")
        return None


def extract_infinitive(soup):
    """Extrait l'infinitif depuis le titre de la page."""

    h2 = soup.find(
        "h2",
        class_="flex items-center space-x-2 px-4 text-xl",
    )

    if not h2:
        return None

    return h2.get_text(" ", strip=True)


# ============================================================================
# EXTRACTION DES CONJUGAISONS
# ============================================================================

def extract_conjugations(soup, result):
    """Extrait toutes les conjugaisons de la page."""

    for h2 in soup.find_all("h2"):
        section_id = h2.get("id")

        if section_id not in SECTION_NAMES:
            continue

        section_name = SECTION_NAMES[section_id]

        container = h2.find_next_sibling("div")

        if not container:
            continue

        section_data = extract_section(container)

        if not section_data:
            continue

        # Les formes impersonnelles sont regroupées ensemble
        if section_name in IMPERSONAL_SECTIONS:
            result["conjugations"].setdefault(
                "Forme Impersonali",
                {},
            )[section_name] = section_data

        else:
            result["conjugations"][section_name] = section_data


def extract_section(container):
    """Extrait les différents temps d'une section."""

    section_data = {}

    for tense_section in container.find_all(
        "section",
        recursive=False,
    ):
        h3 = tense_section.find("h3")

        if not h3:
            continue

        tense_name = h3.get_text(" ", strip=True)

        forms = extract_forms(tense_section)

        if forms:
            section_data[tense_name] = forms

    return section_data


def extract_forms(tense_section):
    """
    Extrait les formes d'un temps.

    Une seule forme :

        "io": "bevevo"

    Plusieurs formes :

        "io": [
            "bevvi",
            "bevetti"
        ]

    Exemple HTML :

        <li><span>io</span> bevvi</li>
        <li><span>io</span> bevetti</li>

    devient :

        {
            "io": [
                "bevvi",
                "bevetti"
            ]
        }

    Les formes impersonnelles sont retournées directement
    sous forme de chaîne.
    """

    forms = {}

    for li in tense_section.find_all("li"):
        span = li.find("span")

        # --------------------------------------------------------------------
        # Forme impersonnelle
        # --------------------------------------------------------------------

        if span and not span.get_text(strip=True):
            value = li.get_text(" ", strip=True)

            if value:
                return value

            continue

        # --------------------------------------------------------------------
        # Forme personnelle
        # --------------------------------------------------------------------

        if not span:
            continue

        person = span.get_text(" ", strip=True)

        if not person:
            continue

        full_text = li.get_text(" ", strip=True)

        # Retire le pronom personnel du début
        value = full_text[len(person):].strip()

        if not value:
            continue

        # --------------------------------------------------------------------
        # Première forme trouvée
        # --------------------------------------------------------------------

        if person not in forms:
            forms[person] = value

        # --------------------------------------------------------------------
        # Plusieurs formes pour la même personne
        # --------------------------------------------------------------------

        else:
            # Transforme la première forme en liste
            if not isinstance(forms[person], list):
                forms[person] = [forms[person]]

            forms[person].append(value)

    return forms


# ============================================================================
# GROUPE / RÉGULARITÉ / PRONOMINAL / AUXILIAIRE
# ============================================================================

def get_group_and_regularity(word):
    """
    Récupère depuis Wiktionary :
    - le groupe
    - la régularité
    - le caractère pronominal
    - l'auxiliaire

    Exemples acceptés :

        "verbe irrégulier du premier groupe,
        conjugué avec l’auxiliaire avere"

        "verbe pronominal irrégulier du premier groupe"

        "verbe pronominal régulier du premier groupe,
        conjugué avec l’auxiliaire essere"
    """

    url = f"https://fr.wiktionary.org/wiki/Conjugaison:italien/{word}"

    try:
        html = get_page_content(url)
        soup = BeautifulSoup(html, "html.parser")

        paragraph = soup.find(
            "p",
            {"about": "#mwt1"},
        )

        if not paragraph:
            print(
                f"Informations introuvables sur Wiktionary : "
                f"{word}"
            )
            return None

        text = paragraph.get_text(" ", strip=True)

        # --------------------------------------------------------------------
        # Régularité
        # --------------------------------------------------------------------
        regular_match = re.search(
            r"verbe\s+(?:pronominal\s+)?"
            r"(régulier|irrégulier)",
            text,
        )

        if not regular_match:
            print(
                f"Régularité inconnue pour {word} : "
                f"{text}"
            )
            return None

        regular = regular_match.group(1) == "régulier"

        # --------------------------------------------------------------------
        # Pronominal
        # --------------------------------------------------------------------
        pronominal = bool(
            re.search(
                r"\bverbe\s+pronominal\b",
                text,
            )
        )

        # --------------------------------------------------------------------
        # Groupe
        # --------------------------------------------------------------------
        group_match = re.search(
            r"du\s+(premier|deuxième|troisième)\s+groupe",
            text,
        )

        if not group_match:
            print(
                f"Groupe introuvable pour {word} : "
                f"{text}"
            )
            return None

        group_name = group_match.group(1)

        group = {
            "premier": 1,
            "deuxième": 2,
            "troisième": 3,
        }[group_name]

        # --------------------------------------------------------------------
        # Auxiliaire
        # --------------------------------------------------------------------
        auxiliary_match = re.search(
            r"auxiliaire\s+(\w+)",
            text,
        )

        auxiliary = (
            auxiliary_match.group(1)
            if auxiliary_match
            else None
        )

        return {
            "groupe": group,
            "regulier": regular,
            "pronominal": pronominal,
            "auxiliaire": auxiliary,
        }

    except requests.RequestException as error:
        print(
            f"Erreur HTTP Wiktionary {word} : "
            f"{error}"
        )
        return None

    except Exception as error:
        print(
            f"Erreur Wiktionary {word} : "
            f"{error}"
        )
        return None


def add_group_and_regularity(result):
    """Ajoute les informations grammaticales au résultat."""

    word = result["infinitive"]

    info = get_group_and_regularity(word)

    if not info:
        print(
            f"Informations grammaticales introuvables : "
            f"{word}"
        )
        return None

    result["group"] = info["groupe"]
    result["regular"] = info["regulier"]
    result["pronominal"] = info["pronominal"]
    result["auxiliary"] = info["auxiliaire"]

    return result


# ============================================================================
# TRADUCTION FRANÇAISE — IL CONIUGATORE
# ============================================================================

def get_ilconiugatore_translation(word):
    """
    Récupère la traduction française d'un verbe
    depuis ilconiugatore.com.
    """

    url = (
        "https://www.ilconiugatore.com/php5/index.php"
        f"?l=fr&v={word}"
    )

    try:
        html = get_page_content(url)

        soup = BeautifulSoup(
            html,
            "html.parser",
        )

        translation_link = soup.find(
            "a",
            title=lambda title: (
                title
                and title.startswith("Conjugaison verbe")
            ),
        )

        if translation_link is None:
            print(
                f"Traduction {word} -> fr impossible : "
                "traduction introuvable"
            )
            return None

        translation = translation_link.get_text(
            strip=True
        )

        return translation or None

    except requests.RequestException as error:
        print(
            f"Erreur HTTP ilconiugatore {word} : "
            f"{error}"
        )
        return None

    except Exception as error:
        print(
            f"Erreur ilconiugatore {word} : "
            f"{error}"
        )
        return None


def add_translations_ilconiugatore(result):
    """
    Ajoute la traduction française au résultat.

    Si aucune traduction n'est trouvée,
    le verbe est ignoré.
    """

    word = result["infinitive"]

    print(f"\nTraduction de : {word}")

    translation = get_ilconiugatore_translation(word)

    if not translation:
        print(
            "❌ aucune traduction → "
            "verbe ignoré"
        )
        return None

    result["translations"] = {
        "fr": translation,
    }

    return result


# ============================================================================
# TRADUCTIONS — REVERSO
# ============================================================================

def get_reverso_translations(word, target_lang):
    """
    Récupère les traductions principales d'un verbe
    depuis Reverso Context.
    """

    reverso_lang = REVERSO_LANGUAGES.get(target_lang)

    if reverso_lang is None:
        raise ValueError(
            f"Langue Reverso non supportée : "
            f"{target_lang}"
        )

    url = (
        "https://context.reverso.net/translation/"
        f"italian-{reverso_lang}/{word}"
    )

    try:
        html = get_page_content(url)

        soup = BeautifulSoup(
            html,
            "html.parser",
        )

        translations = []

        for element in soup.select(".display-term"):
            text = element.get_text(
                " ",
                strip=True,
            )

            if text and text not in translations:
                translations.append(text)

        return translations

    except requests.RequestException as error:
        print(
            f"Erreur HTTP Reverso "
            f"{word} -> {target_lang} : "
            f"{error}"
        )
        return []

    except Exception as error:
        print(
            f"Erreur Reverso "
            f"{word} -> {target_lang} : "
            f"{error}"
        )
        return []


def add_translations(result):
    """
    Ajoute les traductions Reverso.

    Si une langue n'a aucune traduction,
    le verbe est ignoré.
    """

    word = result["infinitive"]

    result["translations"] = {}

    print(f"\nTraductions de : {word}")

    for language in REVERSO_LANGUAGES:
        translations = get_reverso_translations(
            word,
            language,
        )

        if not translations:
            print(
                f"  {language}: "
                "❌ aucune traduction → "
                "verbe ignoré"
            )
            return None

        result["translations"][language] = (
            translations[:5]
        )

        print(
            f"  {language}: "
            f"{result['translations'][language]}"
        )

    return result


# ============================================================================
# SCRAPING GLOBAL
# ============================================================================

def scrape_all_verbs(
    max_verbs=None,
    start=None,
    end=None,
):
    """
    Scrape les verbes sélectionnés et retourne
    une liste de dictionnaires.
    """

    verb_urls = get_available_verbs()

    # Limitation du nombre de verbes
    if max_verbs is not None:
        verb_urls = verb_urls[:max_verbs]

    # Sélection d'une tranche
    if start is not None or end is not None:
        verb_urls = verb_urls[start:end]

    print(
        f"{len(verb_urls)} URLs à traiter"
    )

    all_verbs = []

    for index, url in enumerate(
        verb_urls,
        start=1,
    ):
        print(
            f"\n[{index}/{len(verb_urls)}] "
            f"{url}"
        )

        verb = parse_verb_page(url)

        if verb:
            all_verbs.append(verb)

        # Pause pour éviter de surcharger les serveurs
        time.sleep(REQUEST_DELAY)

    return all_verbs


# ============================================================================
# SAUVEGARDE JSON
# ============================================================================

def save_json(data, output_file=OUTPUT_FILE):
    """Sauvegarde les données au format JSON."""

    output_file.write_text(
        json.dumps(
            data,
            indent=2,
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )

    print(
        f"\n{len(data)} verbes sauvegardés dans : "
        f"{output_file}"
    )


# ============================================================================
# PROGRAMME PRINCIPAL
# ============================================================================

def main():

    # ------------------------------------------------------------------------
    # TEST
    # ------------------------------------------------------------------------

    verbs = scrape_all_verbs(
        max_verbs=52
    )

    # ------------------------------------------------------------------------
    # PRODUCTION
    #
    # Pour scraper tous les verbes, remplacer par :
    #
    # verbs = scrape_all_verbs()
    # ------------------------------------------------------------------------

    save_json(verbs)

    # Affiche les deux premiers verbes
    if verbs:
        print("\nDébut du fichier JSON :")

        print(
            json.dumps(
                verbs[:2],
                indent=2,
                ensure_ascii=False,
            )
        )


if __name__ == "__main__":
    main()