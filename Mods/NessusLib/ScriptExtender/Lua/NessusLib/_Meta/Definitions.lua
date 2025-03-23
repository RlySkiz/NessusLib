MODUUID = ModuleUUID
MODNAME = Ext.Mod.GetMod(MODUUID).Info.Name
MODVERSION = Ext.Mod.GetMod(MODUUID).Info.ModVersion
NULLUUID = "00000000-0000-0000-0000-000000000000"
Definitions = {}

Definitions.OriginUUID = {
    Wyll = "S_Player_Wyll_c774d764-4a17-48dc-b470-32ace9ce447d",
    ShadowHeart = "S_Player_ShadowHeart_3ed74f06-3c60-42dc-83f6-f034cb47c679",
    Laezel = "S_Player_Laezel_58a69333-40bf-8358-1d17-fff240d7fb12",
    Astarion = "S_Player_Astarion_c7c13742-bacd-460a-8f65-f864fe41f255",
    Gale = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604",
    Jaheira = "S_Player_Jaheira_91b6b200-7d00-4d62-8dc9-99e8339dfa1a",
    Minsc = "S_Player_Minsc_0de603c5-42e2-4811-9dad-f652de080eba",
    Karlach = "S_Player_Karlach_2c76687d-93a2-477b-8b18-8a14b549304c",
    Minthara = "S_GOB_DrowCommander_25721313-0c15-4935-8176-9f134385451b",
    Halsin = "S_GLO_Halsin_7628bc0e-52b8-42a7-856a-13a6fd413323",
}

Definitions.EquipmentSlots = {
    --Equipment
    Boots = "Boots",
    Breast = "Breast",
    Cloak = "Cloak",
    Gloves = "Gloves",
    Helmet = "Helmet",
    --Armour
    Underwear = "Underwear",
    VanityBody = "VanityBody",
    VanityBoots = "VanityBoots",
    --Weapons
    MeleeMainHand = "MeleeMainHand",
    MeleeOffHand = "MeleeOffHand",
    RangedMainHand = "RangedMainHand",
    RangedOffHand = "RangedOffHand"
}

Definitions.NPCEquipmentVisualSlots = {
    ["Footwear"] = true,
    ["Body"] = true,
    ["Gloves"] = true,
    ["Cloak"] = true,
    ["Underwear"] = true
}

Definitions.Race = {
    HUMANOID = "899d275e-9893-490a-9cd5-be856794929f",
    HUMAN = "0eb594cb-8820-4be6-a58d-8be7a1a98fba",
    GITHYANKI = "bdf9b779-002c-4077-b377-8ea7c1faa795",
    TIEFLING = "b6dccbed-30f3-424b-a181-c4540cf38197",
    ELF = "6c038dcb-7eb5-431d-84f8-cecfaf1c0c5a",
    HALF_ELF = "45f4ac10-3c89-4fb2-b37d-f973bb9110c0",
    DWARF = "0ab2874d-cfdc-405e-8a97-d37bfbb23c52",
    HALFLING = "78cd3bcc-1c43-4a2a-aa80-c34322c16a04",
    GNOME = "f1b3f884-4029-4f0f-b158-1f9fe0ae5a0d",
    DROW = "4f5d1434-5175-4fa9-b7dc-ab24fba37929",
    DRAGONBORN = "9c61a74a-20df-4119-89c5-d996956b6c66",
    HALF_ORC = "5c39a726-71c8-4748-ba8d-f768b3c11a91",
}

Definitions.RaceTag = {
    HUMAN = "69fd1443-7686-4ca9-9516-72ec0b9d94d7",
    GITHYANKI = "677ffa76-2562-4217-873e-2253d4720ba4",
    TIEFLING = "aaef5d43-c6f3-434d-b11e-c763290dbe0c",
    ELF = "351f4e42-1217-4c06-b47a-443dcf69b111",
    HALF_ELF = "34317158-8e6e-45a2-bd1e-6604d82fdda2",
    DWARF = "486a2562-31ae-437b-bf63-30393e18cbdd",
    HALFLING = "b99b6a5d-8445-44e4-ac58-81b2ee88aab1",
    GNOME = "1f0551f3-d769-47a9-b02b-5d3a8c51978c",
    DROW = "a672ac1d-d088-451a-9537-3da4bf74466c",
    HALF_ORC = "3311a9a9-cdbc-4b05-9bf6-e02ba1fc72a3",
    DRAGONBORN = "02e5e9ed-b6b2-4524-99cd-cb2bc84c754a",
}

Definitions.NonEnglishCharMap = {
    ["á"] = "a", ["é"] = "e", ["í"] = "i", ["ó"] = "o", ["ú"] = "u",
    ["Á"] = "A", ["É"] = "E", ["Í"] = "I", ["Ó"] = "O", ["Ú"] = "U",
    ["ä"] = "a", ["ë"] = "e", ["ï"] = "i", ["ö"] = "o", ["ü"] = "u",
    ["Ä"] = "A", ["Ë"] = "E", ["Ï"] = "I", ["Ö"] = "O", ["Ü"] = "U",
    ["à"] = "a", ["è"] = "e", ["ì"] = "i", ["ò"] = "o", ["ù"] = "u",
    ["À"] = "A", ["È"] = "E", ["Ì"] = "I", ["Ò"] = "O", ["Ù"] = "U",
    ["â"] = "a", ["ê"] = "e", ["î"] = "i", ["ô"] = "o", ["û"] = "u",
    ["Â"] = "A", ["Ê"] = "E", ["Î"] = "I", ["Ô"] = "O", ["Û"] = "U",
    ["ã"] = "a", ["õ"] = "o", ["ñ"] = "n",
    ["Ã"] = "A", ["Õ"] = "O", ["Ñ"] = "N",
    ["ç"] = "c", ["Ç"] = "C",
    ["ß"] = "ss",
    ["ø"] = "o", ["Ø"] = "O",
    ["å"] = "a", ["Å"] = "A",
    ["æ"] = "ae", ["Æ"] = "AE",
    ["œ"] = "oe", ["Œ"] = "OE",
    -- Cyrillic characters
    ["А"] = "A", ["Б"] = "B", ["В"] = "V", ["Г"] = "G", ["Д"] = "D",
    ["Е"] = "E", ["Ё"] = "E", ["Ж"] = "Zh", ["З"] = "Z", ["И"] = "I",
    ["Й"] = "I", ["К"] = "K", ["Л"] = "L", ["М"] = "M", ["Н"] = "N",
    ["О"] = "O", ["П"] = "P", ["Р"] = "R", ["С"] = "S", ["Т"] = "T",
    ["У"] = "U", ["Ф"] = "F", ["Х"] = "Kh", ["Ц"] = "Ts", ["Ч"] = "Ch",
    ["Ш"] = "Sh", ["Щ"] = "Shch", ["Ъ"] = "", ["Ы"] = "Y", ["Ь"] = "",
    ["Э"] = "E", ["Ю"] = "Yu", ["Я"] = "Ya",
    ["а"] = "a", ["б"] = "b", ["в"] = "v", ["г"] = "g", ["д"] = "d",
    ["е"] = "e", ["ё"] = "e", ["ж"] = "zh", ["з"] = "z", ["и"] = "i",
    ["й"] = "i", ["к"] = "k", ["л"] = "l", ["м"] = "m", ["н"] = "n",
    ["о"] = "o", ["п"] = "p", ["р"] = "r", ["с"] = "s", ["т"] = "t",
    ["у"] = "u", ["ф"] = "f", ["х"] = "kh", ["ц"] = "ts", ["ч"] = "ch",
    ["ш"] = "sh", ["щ"] = "shch", ["ъ"] = "", ["ы"] = "y", ["ь"] = "",
    ["э"] = "e", ["ю"] = "yu", ["я"] = "ya",
    -- Misc others
    ["ą"] = "a", ["ć"] = "c", ["ę"] = "e", ["ł"] = "l", ["ń"] = "n",
    ["ś"] = "s", ["ź"] = "z", ["ż"] = "z",
    ["Ą"] = "A", ["Ć"] = "C", ["Ę"] = "E", ["Ł"] = "L", ["Ń"] = "N",
    ["Ś"] = "S", ["Ź"] = "Z", ["Ż"] = "Z",
    ["ő"] = "o", ["ű"] = "u", ["Ő"] = "O", ["Ű"] = "U",
    ["ă"] = "a", ["ș"] = "s", ["ț"] = "t",
    ["Ă"] = "A", ["Ș"] = "S", ["Ț"] = "T",
}