import os
import json
import xml.etree.ElementTree as ET
import glob

BASE_DIR = r"d:\TRAE\文明6\DLC"

ENTITY_TABLES = {
    "Types", "Buildings", "Districts", "Improvements", "Units",
    "Technologies", "Civics", "Policies", "Beliefs", "Resources",
    "Features", "Leaders", "Civilizations", "Governments", "Governors",
    "Modifiers", "Eras", "GlobalParameters", "Projects", "Alliances",
    "Emergencies", "Moments", "Wars", "Victories", "Scoring",
    "UnitAbilities", "UnitPromotions", "Agendas", "Happinesses",
    "LoyaltyLevels", "Notifications", "Congress", "RandomEvents",
    "Routes", "GreatWorks", "GoodyHuts", "TurnPhases", "Maps",
    "Traits", "TypeProperties", "TypeTags", "Tags", "UnitAiInfos",
    "UnitUpgrades", "BuildingPrereqs", "BoostNames", "Boosts",
    "CivilizationLevels", "CivilizationLeaders", "LeaderTraits",
    "TraitModifiers", "ModifierArguments", "DiplomaticActions",
    "GreatPersonIndividuals", "GreatWorks", "RequirementSets",
    "RequirementSetRequirements", "Requirements", "RequirementArguments",
    "DiplomaticVisibilitySources", "GovernorPromotions",
    "StartBiasResources", "StartBiasTerrains", "StartBiasFeatures",
    "StartBiasRivers", "MomentIllustrations", "CommémorationQuests",
    "CommemorationModifiers", "NamedMountains", "NamedRivers",
    "NamedDeserts", "NamedVolcanoes", "NamedLakes", "NamedSeas",
    "AiListTypes", "AiLists", "AiFavoredItems", "AiTeams",
    "AiOperationTeams", "OpTeamRequirements", "PlotEvalConditions",
    "GameCapabilities", "GoodyHutSubTypes", "TurnPhases",
    "Route_ValidFeatures", "Route_ValidTerrains",
    "RandomEventListSizes", "RandomEventLists", "RandomEventChoices",
    "RandomEventScoringEvents", "Resolutions", "ProposalDecisions",
    "AgendaPreferredLeaders", "HistoricRankings",
    "UnitCommands", "UnitOperations", "OperationLimits",
    "UnitReplaces", "UnitUpgrades", "UnitAbilityModifiers",
    "Building_YieldChanges", "Building_GreatPersonPoints",
    "Building_GreatWorks", "Building_ValidFeatures",
    "Building_ValidTerrains", "District_ValidTerrains",
    "Improvement_ValidTerrains", "Improvement_ValidFeatures",
    "Improvement_ValidResources", "Improvement_BonusYieldChanges",
    "Feature_AdjacentYields", "Feature_YieldChanges",
    "TechnologyPrereqs", "CivicPrereqs", "PolicyModifiers",
    "BeliefModifiers", "GovernmentModifiers", "GovernmentSlots",
    "LeagueSpecialSessions", "EmergencyRewards",
    "EmergencyAlliances", "AllowedMoves",
    "Yields", "Resource_YieldChanges", "Resource_Consumption",
    "Resource_Harvests", "Improvement_TechYieldChanges",
    "Building_ResourceCosts", "Unit_BuildingPrereqs",
    "GreatPersonIndividualBirthModifiers",
    "GreatPersonIndividualActionModifiers",
    "UnitAbilityCommands", "ModifierStrings",
    "AiOperationDefs", "AiOperationLists",
}

def parse_xml_file(filepath):
    """Parse a single XML file and extract all Row entities."""
    try:
        tree = ET.parse(filepath)
        root = tree.getroot()
    except ET.ParseError as e:
        print(f"  SKIP (parse error): {filepath} - {e}")
        return {}
    
    results = {}
    
    for table_elem in root:
        table_name = table_elem.tag
        
        # Skip non-entity tables
        if table_name == 'Update' or table_name == 'Delete' or table_name == 'Replace':
            continue
        
        rows = []
        for row_elem in table_elem.findall('Row'):
            row_data = {}
            
            # Get attributes
            for key, val in row_elem.attrib.items():
                row_data[key] = val
            
            # Get child elements (used in some tables like ModifierArguments)
            for child in row_elem:
                child_text = (child.text or '').strip()
                if child_text:
                    row_data[child.tag] = child_text
            
            if row_data:
                rows.append(row_data)
        
        # Also handle Update elements that modify existing data
        for update_elem in table_elem.findall('Update'):
            where_elem = update_elem.find('Where')
            set_elem = update_elem.find('Set')
            if where_elem is not None and set_elem is not None:
                update_data = {"_action": "update"}
                for key, val in where_elem.attrib.items():
                    update_data["_where_" + key] = val
                for child in set_elem:
                    child_text = (child.text or '').strip()
                    if child_text:
                        update_data["_set_" + child.tag] = child_text
                for key, val in set_elem.attrib.items():
                    update_data["_set_" + key] = val
                rows.append(update_data)
        
        if rows:
            if table_name not in results:
                results[table_name] = []
            results[table_name].extend(rows)
    
    return results

def get_dlc_name(filepath):
    """Extract DLC name from file path."""
    rel = os.path.relpath(filepath, BASE_DIR)
    parts = rel.split(os.sep)
    if len(parts) >= 1:
        return parts[0]
    return "Unknown"

def main():
    all_entities = []
    total_files = 0
    total_rows = 0
    
    dlc_dirs = [
        "Expansion1",
        "Expansion2",
        "Australia",
        "Aztec_Montezuma",
        "Babylon",
        "BarbarianClansMode",
        "Byzantium_Gaul",
        "CatherineDeMedici",
        "Ethiopia",
        "GranColombia_Maya",
        "GreatBuilders",
        "GreatNegotiators",
        "GreatWarlords",
        "JuliusCaesar",
        "Nubia_Amanitore",
        "Portugal",
        "RulersOfChina",
        "TeddyRoosevelt",
        "Macedonia_Persia",
        "Poland_Jadwiga",
        "Vikings",
        "Indonesia_Khmer",
    ]
    
    for dlc_dir in dlc_dirs:
        dlc_path = os.path.join(BASE_DIR, dlc_dir)
        if not os.path.isdir(dlc_path):
            continue
        
        data_dir = os.path.join(dlc_path, "Data")
        if not os.path.isdir(data_dir):
            continue
        
        xml_files = glob.glob(os.path.join(data_dir, "*.xml"))
        
        for xml_file in xml_files:
            filename = os.path.basename(xml_file)
            print(f"Parsing: {dlc_dir}/{filename}")
            
            tables = parse_xml_file(xml_file)
            
            for table_name, rows in tables.items():
                for row in rows:
                    entity = {
                        "dlc_source": dlc_dir,
                        "source_file": filename,
                        "table_name": table_name,
                    }
                    entity.update(row)
                    all_entities.append(entity)
                    total_rows += 1
            
            total_files += 1
    
    print(f"\nTotal files parsed: {total_files}")
    print(f"Total entities extracted: {total_rows}")
    
    output_path = os.path.join(BASE_DIR, "all_dlc_entities.json")
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(all_entities, f, ensure_ascii=False, indent=2)
    
    print(f"Output written to: {output_path}")
    
    # Also write a summary
    summary = {}
    for entity in all_entities:
        key = f"{entity['dlc_source']}/{entity['table_name']}"
        summary[key] = summary.get(key, 0) + 1
    
    summary_path = os.path.join(BASE_DIR, "all_dlc_entities_summary.json")
    with open(summary_path, 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    print(f"Summary written to: {summary_path}")

if __name__ == "__main__":
    main()