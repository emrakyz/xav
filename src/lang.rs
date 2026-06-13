use std::borrow::Cow;

#[must_use]
pub fn to_bcp47(code: &str) -> Cow<'static, str> {
    canonical(code).map_or_else(|| Cow::Owned(code.to_owned()), Cow::Borrowed)
}

fn canonical(code: &str) -> Option<&'static str> {
    Some(match code {
        "eng" => "en",
        "fra" | "fre" => "fr",
        "deu" | "ger" => "de",
        "spa" => "es",
        "ita" => "it",
        "por" => "pt",
        "rus" => "ru",
        "jpn" => "ja",
        "zho" | "chi" => "zh",
        "kor" => "ko",
        "ara" => "ar",
        "hin" => "hi",
        "ben" => "bn",
        "pan" => "pa",
        "tam" => "ta",
        "tel" => "te",
        "mar" => "mr",
        "urd" => "ur",
        "guj" => "gu",
        "kan" => "kn",
        "mal" => "ml",
        "nld" | "dut" => "nl",
        "swe" => "sv",
        "nor" => "no",
        "nob" => "nb",
        "nno" => "nn",
        "dan" => "da",
        "fin" => "fi",
        "isl" | "ice" => "is",
        "pol" => "pl",
        "ces" | "cze" => "cs",
        "slk" | "slo" => "sk",
        "slv" => "sl",
        "hrv" => "hr",
        "srp" => "sr",
        "bos" => "bs",
        "mkd" | "mac" => "mk",
        "bul" => "bg",
        "ukr" => "uk",
        "bel" => "be",
        "ron" | "rum" => "ro",
        "hun" => "hu",
        "ell" | "gre" => "el",
        "tur" => "tr",
        "heb" => "he",
        "fas" | "per" => "fa",
        "tha" => "th",
        "vie" => "vi",
        "ind" => "id",
        "msa" | "may" => "ms",
        "tgl" => "tl",
        "swa" => "sw",
        "zul" => "zu",
        "xho" => "xh",
        "afr" => "af",
        "hau" => "ha",
        "amh" => "am",
        "yor" => "yo",
        "ibo" => "ig",
        "som" => "so",
        "mlt" => "mt",
        "gle" => "ga",
        "gla" => "gd",
        "cym" | "wel" => "cy",
        "eus" | "baq" => "eu",
        "cat" => "ca",
        "glg" => "gl",
        "sqi" | "alb" => "sq",
        "lav" => "lv",
        "lit" => "lt",
        "est" => "et",
        "nep" => "ne",
        "sin" => "si",
        "pus" | "pbt" => "ps",
        "lao" => "lo",
        "mon" => "mn",
        "khm" => "km",
        "mya" | "bur" => "my",
        "kat" | "geo" => "ka",
        "hye" | "arm" => "hy",
        "aze" => "az",
        "kaz" => "kk",
        "uzb" => "uz",
        "kir" => "ky",
        "tgk" => "tg",
        "tuk" => "tk",
        "hat" => "ht",
        "kur" => "ku",
        "snd" => "sd",
        "und" => "und",
        _ => return None,
    })
}

#[must_use]
pub fn lang_name(tag: &str) -> Cow<'static, str> {
    let mut parts = tag.split('-');
    let primary = parts.next().unwrap_or(tag);
    let base = primary_name(primary);
    let mut name = String::new();
    let mut open = false;
    for sub in parts {
        let qual = qualifier(sub);
        if qual.is_empty() {
            continue;
        }
        if open {
            name.push_str(", ");
        } else {
            name.push_str(base.unwrap_or(primary));
            name.push_str(" (");
            open = true;
        }
        name.push_str(qual);
    }
    if open {
        name.push(')');
        Cow::Owned(name)
    } else {
        base.map_or_else(|| Cow::Owned(primary.to_owned()), Cow::Borrowed)
    }
}

fn qualifier(sub: &str) -> &str {
    if sub.len() == 4 && sub.starts_with(|c: char| c.is_ascii_alphabetic()) {
        script_name(sub)
    } else if is_region(sub) {
        region_name(sub)
    } else {
        ""
    }
}

fn is_region(sub: &str) -> bool {
    (sub.len() == 2 && sub.bytes().all(|b| b.is_ascii_alphabetic()))
        || (sub.len() == 3 && sub.bytes().all(|b| b.is_ascii_digit()))
}

fn primary_name(p: &str) -> Option<&'static str> {
    Some(match p {
        "en" => "English",
        "fr" => "French",
        "de" => "German",
        "es" => "Spanish",
        "it" => "Italian",
        "pt" => "Portuguese",
        "ru" => "Russian",
        "ja" => "Japanese",
        "zh" => "Chinese",
        "ko" => "Korean",
        "ar" => "Arabic",
        "hi" => "Hindi",
        "bn" => "Bengali",
        "pa" => "Punjabi",
        "ta" => "Tamil",
        "te" => "Telugu",
        "mr" => "Marathi",
        "ur" => "Urdu",
        "gu" => "Gujarati",
        "kn" => "Kannada",
        "ml" => "Malayalam",
        "nl" => "Dutch",
        "sv" => "Swedish",
        "no" => "Norwegian",
        "nb" => "Norwegian Bokmal",
        "nn" => "Norwegian Nynorsk",
        "da" => "Danish",
        "fi" => "Finnish",
        "is" => "Icelandic",
        "pl" => "Polish",
        "cs" => "Czech",
        "sk" => "Slovak",
        "sl" => "Slovenian",
        "hr" => "Croatian",
        "sr" => "Serbian",
        "bs" => "Bosnian",
        "mk" => "Macedonian",
        "bg" => "Bulgarian",
        "uk" => "Ukrainian",
        "be" => "Belarusian",
        "ro" => "Romanian",
        "hu" => "Hungarian",
        "el" => "Greek",
        "tr" => "Turkish",
        "he" => "Hebrew",
        "fa" => "Persian",
        "th" => "Thai",
        "vi" => "Vietnamese",
        "id" => "Indonesian",
        "ms" => "Malay",
        "tl" => "Tagalog",
        "fil" => "Filipino",
        "sw" => "Swahili",
        "zu" => "Zulu",
        "xh" => "Xhosa",
        "af" => "Afrikaans",
        "ha" => "Hausa",
        "am" => "Amharic",
        "yo" => "Yoruba",
        "ig" => "Igbo",
        "so" => "Somali",
        "mt" => "Maltese",
        "ga" => "Irish",
        "gd" => "Scottish Gaelic",
        "cy" => "Welsh",
        "eu" => "Basque",
        "ca" => "Catalan",
        "gl" => "Galician",
        "sq" => "Albanian",
        "lv" => "Latvian",
        "lt" => "Lithuanian",
        "et" => "Estonian",
        "ne" => "Nepali",
        "si" => "Sinhala",
        "ps" => "Pashto",
        "lo" => "Lao",
        "mn" => "Mongolian",
        "km" => "Khmer",
        "my" => "Burmese",
        "ka" => "Georgian",
        "hy" => "Armenian",
        "az" => "Azerbaijani",
        "kk" => "Kazakh",
        "uz" => "Uzbek",
        "ky" => "Kyrgyz",
        "tg" => "Tajik",
        "tk" => "Turkmen",
        "ht" => "Haitian Creole",
        "ku" => "Kurdish",
        "sd" => "Sindhi",
        "yue" => "Cantonese",
        "haw" => "Hawaiian",
        "und" => "Undetermined",
        _ => return None,
    })
}

fn script_name(s: &str) -> &str {
    match s {
        "Hans" => "Simplified",
        "Hant" => "Traditional",
        "Latn" => "Latin",
        "Cyrl" => "Cyrillic",
        "Arab" => "Arabic",
        "Hani" => "Han",
        "Jpan" => "Japanese",
        "Kore" => "Korean",
        "Kana" => "Katakana",
        "Hira" => "Hiragana",
        "Hang" => "Hangul",
        "Deva" => "Devanagari",
        "Thai" => "Thai",
        "Hebr" => "Hebrew",
        "Grek" => "Greek",
        _ => s,
    }
}

fn region_name(r: &str) -> &str {
    match r {
        "001" => "World",
        "002" => "Africa",
        "005" => "South America",
        "009" => "Oceania",
        "013" => "Central America",
        "019" => "Americas",
        "021" => "Northern America",
        "029" => "Caribbean",
        "142" => "Asia",
        "150" => "Europe",
        "419" => "Latin America",
        "BR" => "Brazil",
        "PT" => "Portugal",
        "US" => "United States",
        "GB" => "United Kingdom",
        "MX" => "Mexico",
        "ES" => "Spain",
        "FR" => "France",
        "CA" => "Canada",
        "DE" => "Germany",
        "AT" => "Austria",
        "CH" => "Switzerland",
        "CN" => "China",
        "TW" => "Taiwan",
        "HK" => "Hong Kong",
        "MO" => "Macau",
        "JP" => "Japan",
        "KR" => "Korea",
        "IN" => "India",
        "AU" => "Australia",
        "NZ" => "New Zealand",
        "IE" => "Ireland",
        "ZA" => "South Africa",
        "RU" => "Russia",
        "IT" => "Italy",
        "NL" => "Netherlands",
        "BE" => "Belgium",
        "AR" => "Argentina",
        "CO" => "Colombia",
        "CL" => "Chile",
        "PE" => "Peru",
        "VE" => "Venezuela",
        "SE" => "Sweden",
        "NO" => "Norway",
        "DK" => "Denmark",
        "FI" => "Finland",
        "PL" => "Poland",
        "TR" => "Turkey",
        "GR" => "Greece",
        "UA" => "Ukraine",
        "CZ" => "Czechia",
        "HU" => "Hungary",
        "RO" => "Romania",
        "SA" => "Saudi Arabia",
        "EG" => "Egypt",
        "IL" => "Israel",
        "IR" => "Iran",
        "TH" => "Thailand",
        "VN" => "Vietnam",
        "ID" => "Indonesia",
        "MY" => "Malaysia",
        "PH" => "Philippines",
        "SG" => "Singapore",
        _ => r,
    }
}
