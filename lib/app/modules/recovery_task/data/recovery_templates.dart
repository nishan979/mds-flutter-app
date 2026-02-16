enum RecoveryStepType {
  toggle, // Simple "Done" button or switch (e.g., DND)
  timer, // Countdown (e.g., Breathing)
  textInput, // Input field (e.g., Reflection)
  choice, // Selection chips (e.g., Pick repair action)
  checkbox, // Simple tick (e.g., "I promise to...")
}

class RecoveryStepData {
  final String id;
  final String title;
  final String subtitle;
  final RecoveryStepType type;
  final dynamic content; // Duration (int), Options (List<String>), etc.

  RecoveryStepData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.content,
  });
}

class RecoveryTaskTemplate {
  final String id;
  final String title; // "Daily Recovery Task" title
  final String description; // "Why this matters"
  final String reflectionPrompt; // "One sentence..."
  final int estimatedMinutes;
  final List<RecoveryStepData> steps;

  RecoveryTaskTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.reflectionPrompt,
    required this.estimatedMinutes,
    required this.steps,
  });
}

// Hardcoded Templates (Families A-E)
final List<RecoveryTaskTemplate> kRecoveryTemplates = [
  // A) Reflection + Pattern Spotting
  RecoveryTaskTemplate(
    id: 'template_a',
    title: "Deep Reflection Reset",
    description: "Understand the trigger to prevent it next time.",
    reflectionPrompt: "What emotion was I avoiding?",
    estimatedMinutes: 5,
    steps: [
      RecoveryStepData(
        id: 'step_breath',
        title: "Center Yourself",
        subtitle: "Take 5 deep breaths to clear the fog.",
        type: RecoveryStepType.timer,
        content: 30, // 30 seconds
      ),
      RecoveryStepData(
        id: 'step_reflect_1',
        title: "Identify the Trigger",
        subtitle: "Was it stress, boredom, or fatigue?",
        type: RecoveryStepType.textInput,
      ),
      RecoveryStepData(
        id: 'step_reflect_2',
        title: "Gateway Analysis",
        subtitle: "Which app or action started the slip?",
        type: RecoveryStepType.textInput,
      ),
      RecoveryStepData(
        id: 'step_commit',
        title: "Commit to Focus",
        subtitle: "I will not slip again today.",
        type: RecoveryStepType.checkbox,
      ),
    ],
  ),

  // B) Repair Action
  RecoveryTaskTemplate(
    id: 'template_b',
    title: "Environment Repair",
    description: "Fix your physical space to fix your mental space.",
    reflectionPrompt: "How does my environment affect my focus?",
    estimatedMinutes: 10,
    steps: [
      RecoveryStepData(
        id: 'step_tidy',
        title: "Tidy Workspace",
        subtitle: "Clear your desk of clutter.",
        type: RecoveryStepType.checkbox,
      ),
      RecoveryStepData(
        id: 'step_hydrate',
        title: "Physical Reset",
        subtitle: "Drink a glass of water.",
        type: RecoveryStepType.toggle,
      ),
      RecoveryStepData(
        id: 'step_repair_choice',
        title: "Quick Win",
        subtitle: "Choose one small task to complete now.",
        type: RecoveryStepType.choice,
        content: ["File 3 papers", "Wipe screen", "Empty trash", "Stretch"],
      ),
    ],
  ),

  // C) Preventive Setup
  RecoveryTaskTemplate(
    id: 'template_c',
    title: "Future-Proofing",
    description: "Set up safeguards for tomorrow.",
    reflectionPrompt: "What is my biggest distraction risk tomorrow?",
    estimatedMinutes: 5,
    steps: [
      RecoveryStepData(
        id: 'step_schedule',
        title: "Schedule Blocks",
        subtitle: "Define your focus blocks for tomorrow.",
        type: RecoveryStepType.checkbox,
      ),
      RecoveryStepData(
        id: 'step_limits',
        title: "Review App Limits",
        subtitle: "Tighten restrictions if needed.",
        type: RecoveryStepType.toggle,
      ),
      RecoveryStepData(
        id: 'step_bedtime',
        title: "Bedtime Intent",
        subtitle: "Set an alarm for sleep.",
        type: RecoveryStepType.checkbox,
      ),
    ],
  ),

  // D) Micro Discipline Challenge
  RecoveryTaskTemplate(
    id: 'template_d',
    title: "Discipline Drill",
    description: "Rebuild your attention span with a challenge.",
    reflectionPrompt: "Did I feel the urge to check my phone?",
    estimatedMinutes: 12,
    steps: [
      RecoveryStepData(
        id: 'step_phone_down',
        title: "Phone Face Down",
        subtitle: "Physically distance yourself from the device.",
        type: RecoveryStepType.toggle,
      ),
      RecoveryStepData(
        id: 'step_stare',
        title: "Wall Stare",
        subtitle: "Do nothing for 2 minutes. Embrace boredom.",
        type: RecoveryStepType.timer,
        content: 120,
      ),
      RecoveryStepData(
        id: 'step_single_task',
        title: "Single Task Sprint",
        subtitle: "Focus on ONE task for 10 minutes.",
        type: RecoveryStepType.timer,
        content: 600,
      ),
    ],
  ),

  // E) Social/Accountability
  RecoveryTaskTemplate(
    id: 'template_e',
    title: "Accountability Check",
    description: "Externalize your commitment.",
    reflectionPrompt: "Who helps me stay on track?",
    estimatedMinutes: 5,
    steps: [
      RecoveryStepData(
        id: 'step_msg_buddy',
        title: "Message a Buddy",
        subtitle: "Tell someone you are getting back on track.",
        type: RecoveryStepType.checkbox,
      ),
      RecoveryStepData(
        id: 'step_log',
        title: "Log the Slip",
        subtitle: "Be honest with your private log.",
        type: RecoveryStepType.textInput,
      ),
      RecoveryStepData(
        id: 'step_post',
        title: "Feedback Loop",
        subtitle: "Write down one thing to improve.",
        type: RecoveryStepType.textInput,
      ),
    ],
  ),

  // F) Late Night Rescue
  RecoveryTaskTemplate(
    id: 'template_f',
    title: "Late Night Rescue",
    description: "Stop the revenge bedtime procrastination.",
    reflectionPrompt: "Why am I staying up?",
    estimatedMinutes: 5,
    steps: [
      RecoveryStepData(
        id: 'step_blue_light',
        title: "Kill Blue Light",
        subtitle: "Turn on Night Shift / Grayscale",
        type: RecoveryStepType.toggle,
      ),
      RecoveryStepData(
        id: 'step_breathe_relax',
        title: "Decompress",
        subtitle: "4-7-8 Breathing Technique",
        type: RecoveryStepType.timer,
        content: 60,
      ),
      RecoveryStepData(
        id: 'step_alarm',
        title: "Set Alarm",
        subtitle: "Set tomorrow's wake up time",
        type: RecoveryStepType.checkbox,
      ),
    ],
  ),

  // G) Morning Reset
  RecoveryTaskTemplate(
    id: 'template_g',
    title: "Morning Reset",
    description: "Start the day with intention, despite yesterday.",
    reflectionPrompt: "What is my #1 goal today?",
    estimatedMinutes: 5,
    steps: [
      RecoveryStepData(
        id: 'step_water',
        title: "Hydrate First",
        subtitle: "Drink water before checking phone.",
        type: RecoveryStepType.toggle,
      ),
      RecoveryStepData(
        id: 'step_plan',
        title: "Top 3 Priorities",
        subtitle: "Write them down.",
        type: RecoveryStepType.textInput,
      ),
      RecoveryStepData(
        id: 'step_visualize',
        title: "Visualize Success",
        subtitle: "See yourself completing the tasks.",
        type: RecoveryStepType.timer,
        content: 60,
      ),
    ],
  ),
];
