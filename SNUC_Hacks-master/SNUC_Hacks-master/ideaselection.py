import json
from groq import Groq
from typing import Dict, Optional
import logging

class LearningPlatform:
    def __init__(self, api_key: str):
        """Initialize the learning platform with configuration."""
        self.client = Groq(api_key=api_key)
        self.logger = logging.getLogger(__name__)
        logging.basicConfig(level=logging.INFO)

    def elaborate_activity(self, activity_data: Dict) -> Optional[str]:
        """Elaborate on activity steps with improved prompt and error handling."""
        try:
            prompt = f"""
            Provide detailed elaboration for this learning activity:
            Title: {activity_data['title']}
            Concept: {activity_data['concept']}
            Materials: {', '.join(activity_data['materials'])}
            Original Steps: {', '.join(activity_data['steps'])}
            
            Please provide a detailed breakdown including:
            1. Setup Instructions:
               - Detailed preparation steps
               - Safety considerations
               - Material organization
            
            2. Step-by-Step Procedure:
               - Detailed instructions for each step
               - Time allocation for each phase
               - Key points to emphasize
            
            3. Teaching Guidelines:
               - Collaborative aspects: {activity_data['collaborative']}
               - Gamification elements: {activity_data['gamification']}
               - Adaptive learning strategies: {activity_data['adaptive']}
            
            4. Assessment and Extensions:
               - Discussion questions
               - Success criteria
               - Modifications for different skill levels
            
            Format the response as a JSON object with clear sections.
            """
            
            self.logger.info("Requesting activity elaboration from Groq")
            response = self.client.chat.completions.create(
                messages=[{"role": "user", "content": prompt}],
                model="llama-3.3-70b-versatile",
                response_format={"type": "json_object"},
                temperature=0.5
            )
            return response.choices[0].message.content
            
        except Exception as e:
            self.logger.error(f"Error elaborating activity: {str(e)}")
            return None

class ActivityManager:
    """Handle activity selection and display."""
    @staticmethod
    def display_menu() -> str:
        """Display and handle difficulty selection with input validation."""
        difficulty_levels = {
            '1': 'easy',
            '2': 'medium',
            '3': 'hard'
        }
        
        print("\n=== Select Activity Difficulty Level ===")
        print("1. Easy   - Basic concept exploration")
        print("2. Medium - Intermediate experiments")
        print("3. Hard   - Advanced applications")
        
        while True:
            choice = input("\nEnter choice (1-3): ").strip()
            if choice in difficulty_levels:
                return difficulty_levels[choice]
            print("Invalid input. Please enter 1, 2, or 3")
    
    @staticmethod
    def display_activity_details(activity: Dict) -> None:
        """Display the basic activity details before elaboration."""
        print("\n=== Selected Activity ===")
        print(f"Title: {activity['title']}")
        print(f"Concept: {activity['concept']}")
        print("\nMaterials needed:")
        for material in activity['materials']:
            print(f"- {material}")
        print("\nBasic steps:")
        for i, step in enumerate(activity['steps'], 1):
            print(f"{i}. {step}")
        print("\nCollaborative element:", activity['collaborative'])
        print("Gamification:", activity['gamification'])
        print("Adaptive learning:", activity['adaptive'])
    
    @staticmethod
    def save_elaboration(elaborated_data: Dict, output_file: str) -> None:
        """Save elaborated activity data with error handling."""
        try:
            with open(output_file, "w") as f:
                json.dump({"elaborated_activity": elaborated_data}, f, indent=2)
            print(f"\nDetailed instructions saved to {output_file}")
        except Exception as e:
            print(f"Error saving elaboration: {str(e)}")

def main():
    """Main function with improved structure and error handling."""
    try:
        # Configuration
        API_KEY = "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"
        INPUT_FILE = "learning_activities_objects_2025-02-24_10-27-58.json"
        
        # Initialize platform and manager
        platform = LearningPlatform(api_key=API_KEY)
        manager = ActivityManager()
        
        # Load activities from JSON file
        print(f"Loading activities from {INPUT_FILE}")
        try:
            with open(INPUT_FILE) as f:
                activities_data = json.load(f)
        except FileNotFoundError:
            print(f"Error: Could not find file '{INPUT_FILE}'")
            return
        except json.JSONDecodeError:
            print(f"Error: Invalid JSON format in '{INPUT_FILE}'")
            return
        
        # Get user selection
        selected_level = manager.display_menu()
        activity = activities_data['activities'][selected_level][0]
        
        # Display selected activity details
        manager.display_activity_details(activity)
        
        # Confirm elaboration
        if input("\nWould you like detailed instructions for this activity? (y/n): ").lower() != 'y':
            return
        
        print("\nGenerating detailed instructions...")
        elaborated = platform.elaborate_activity(activity)
        
        if elaborated:
            # Save elaborated instructions
            output_file = INPUT_FILE.replace("activities_objects", "elaborated_activity")
            manager.save_elaboration(json.loads(elaborated), output_file)
            
            # Display elaborated instructions
            print("\n=== Detailed Instructions ===")
            print(json.dumps(json.loads(elaborated), indent=2))
        
    except Exception as e:
        print(f"Error in main execution: {str(e)}")

if __name__ == "__main__":
    main()