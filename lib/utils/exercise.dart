class Exercise {
  final String name;
  final List<String> instructions;
  final String image;
  final String gif;
  final int trackedKeypoint;
  final int trackingDirection;
  final bool fullRepPosition; // up -> true, down -> false
  final String formCorrectnessModel;
  final List<String> targetedMuscles;
  final List<String> cameraInstructions;
  final List<String> correctionAdvice;

  Exercise({
    required this.name,
    required this.instructions,
    required this.image,
    required this.gif,
    required this.trackedKeypoint,
    required this.trackingDirection,
    required this.fullRepPosition,
    required this.formCorrectnessModel,
    required this.targetedMuscles,
    required this.cameraInstructions,
    required this.correctionAdvice,
  });
}

final List<Exercise> availableExercises = [
  Exercise(
    name: 'Push Ups',
    instructions: [
      'Start in a plank position with your arms straight and your hands shoulder-width apart.',
      'Lower your body until your chest touches the floor.',
      'Push your body back up to the starting position.',
      'Repeat for the desired number of reps.'
    ],
    image: "assets/images/push_up.png",
    gif: 'assets/images/push_up.gif',
    trackedKeypoint: kKeypointDict['left_shoulder'] as int,
    trackingDirection: 0,
    fullRepPosition: true,
    formCorrectnessModel: 'models/pushUp_v3.tflite',
    targetedMuscles: ['Chest', 'Triceps', 'Shoulders'],
    cameraInstructions: [
      "For this exercise, you need to place your phone in a landscape orientation.",
      "While exercising, your phone needs to be in a stable position (i.e. not move).",
      "Your phone's camera should be able to view your entire body's left side, specially your left shoulder, since we use it to track your reps.",
      "Start a warmup for 15 seconds. This is necessary for our AI to calculate some statistics off your body.",
      "Once you're done with your warmup, you should be able to start your workout.",
      "Once you have started a set, you should perform the required number of reps.",
      "When you're done, go back to your phone and start your rest period.",
      "If you want to, you can always just finish your set early and take your rest. Remember, exercise is supposed to be fun!",
    ],
    correctionAdvice: [
      'Keep your body straight and aligned throughout the movement',
      'Keep your elbows close to your body, not flared out',
      'Lower your body until your chest almost touches the floor',
      'Push through your palms evenly to maintain balance',
    ],
  ),
  Exercise(
    name: 'Pull Ups',
    instructions: [
      'Start by grabbing the pull-up bar with your palms facing away from you and your hands shoulder-width apart.',
      'Hang from the bar with your arms extended and your feet off the ground.',
      'Pull your body up towards the bar until your chin is above the bar.',
      'Lower your body back down to the starting position.',
      'Repeat for the desired number of reps.'
    ],
    image: "assets/images/pull_up.png",
    gif: 'assets/images/pull_up.gif',
    trackedKeypoint: kKeypointDict['nose'] as int,
    trackingDirection: 1,
    fullRepPosition: false,
    formCorrectnessModel: 'models/pullUp_v2.tflite',
    targetedMuscles: ['Back', 'Biceps', 'Shoulders'],
    cameraInstructions: [
      "For this exercise, you need to place your phone in a portrait orientation.",
      "While exercising, your phone needs to be in a stable position (i.e. not move).",
      "Your phone's camera should be able to view your entire body's anterior, specially your nose, since we use it to track your reps.",
      "Start a warmup for 15 seconds. This is necessary for our AI to calculate some statistics off your body.",
      "Once you're done with your warmup, you should be able to start your workout.",
      "Once you have started a set, you should perform the required number of reps.",
      "When you're done, go back to your phone and start your rest period.",
      "If you want to, you can always just finish your set early and take your rest. Remember, exercise is supposed to be fun!",
    ],
    correctionAdvice: [
      'Keep your shoulders down and away from your ears',
      "Engage your core and don't swing your body",
      'Pull your elbows down and back, not out to the sides',
      'Lower your body all the way down before starting the next rep',
    ],
  ),
  Exercise(
    name: 'Tadasana',
    instructions: [
      'Stand with your feet together and your arms at your sides.',
      'Press down through your feet and engage your thigh muscles.',
      'Lift your chest and roll your shoulders back.',
      'Extend your arms overhead with your palms facing each other.',
      'Reach upward through your fingertips while keeping your shoulders relaxed.',
      'Hold the pose for several breaths.'
    ],
    image: "assets/images/tadasana.jpg",
    gif: 'assets/images/tadasana.gif',
    trackedKeypoint: kKeypointDict['right_wrist'] as int,
    trackingDirection: 1, 
    fullRepPosition: true,
    formCorrectnessModel: 'models/tadasana_latest97_V1.tflite',
    targetedMuscles: ['Core', 'Legs', 'Back'],
    cameraInstructions: [
      "For this exercise, you need to place your phone in a portrait orientation.",
      "While exercising, your phone needs to be in a stable position (i.e. not move).",
      "Your phone's camera should be able to view your entire body's anterior, specially your nose, since we use it to track your reps.",
      "Start a warmup for 15 seconds. This is necessary for our AI to calculate some statistics off your body.",
      "Once you're done with your warmup, you should be able to start your workout.",
      "Once you have started a set, you should perform the required number of reps.",
      "When you're done, go back to your phone and start your rest period.",
      "If you want to, you can always just finish your set early and take your rest. Remember, exercise is supposed to be fun!",
    ],
    correctionAdvice: [
      'Ensure your feet are firmly grounded and evenly distributing your weight.',
      'Engage your core muscles to maintain stability.',
      'Keep your spine straight and elongated.',
      'Relax your neck and gaze straight ahead.',
    ],
  ),
  Exercise(
    name: 'Vajrasana',
    instructions: [
      'Kneel on the floor with your toes together and heels apart.', 
      'Sit back onto your heels.',
      'Rest your hands on your knees, palms down..', 
      'Keep your spine straight, shoulders relaxed.',
      'Hold the pose and breathe deeply.' 
    ],
    image: "assets/images/vajrasana.jpg",
    gif: 'assets/images/vajrasana.gif',
    trackedKeypoint:  kKeypointDict['right_shoulder'] as int,
    trackingDirection: 1,
    fullRepPosition: false, 
    formCorrectnessModel: 'models/VAJRA.tflite', // A model trained on Vajrasana variations
    targetedMuscles: ['Quadriceps', 'Pelvic Floor', 'Spine stabilizers'], 
    cameraInstructions: [ 
      "For this exercise, you need to place your phone in a portrait orientation.",
      "While exercising, your phone needs to be in a stable position (i.e. not move).",
      "Your phone's camera should be able to view your entire body's anterior, specially your nose, since we use it to track your reps.",
      "Start a warmup for 15 seconds. This is necessary for our AI to calculate some statistics off your body.",
      "Once you're done with your warmup, you should be able to start your workout.",
      "Once you have started a set, you should perform the required number of reps.",
      "When you're done, go back to your phone and start your rest period.",
      "If you want to, you can always just finish your set early and take your rest. Remember, exercise is supposed to be fun!",
    ], 
    correctionAdvice: [ 
        'Keep your spine tall and straight.', 
        'Relax your shoulders away from your ears.', 
        'Ensure your hips are resting evenly on your heels.',
        
    ], 
  ),
  Exercise(
    name: 'Squats',
    instructions: [
      'Stand with your feet shoulder-width apart and your toes pointing slightly outward.',
      'Lower your body by bending your knees and pushing your hips back as if you are sitting on a chair.',
      'Keep your chest up and your back straight as you descend until your thighs are parallel to the ground.',
      'Push through your heels to return to the starting position.',
      'Repeat for the desired number of reps.'
    ],
    image: "assets/images/squat.jpg",
    gif: 'assets/images/squat.gif',
    trackedKeypoint: kKeypointDict['nose'] as int,
    trackingDirection: 1,
    fullRepPosition: true,
    formCorrectnessModel: 'models/squat.tflite',
    targetedMuscles: [
      'Quads',
      'Hamstrings',
      'Glutes',
    ],
    cameraInstructions: [
      "For this exercise, you need to place your phone in a portrait orientation.",
      "While exercising, your phone needs to be in a stable position (i.e. not move).",
      "Your phone's camera should be able to view your entire body's anterior, specially your nose, since we use it to track your reps.",
      "Start a warmup for 15 seconds. This is necessary for our AI to calculate some statistics off your body.",
      "Once you're done with your warmup, you should be able to start your workout.",
      "Once you have started a set, you should perform the required number of reps.",
      "When you're done, go back to your phone and start your rest period.",
      "If you want to, you can always just finish your set early and take your rest. Remember, exercise is supposed to be fun!",
    ],
    correctionAdvice: [
      'Keep your knees in line with your toes',
      'Squat down until your thighs are parallel to the ground',
      'Keep your chest up and back straight',
      'Push through your heels to stand up',
    ],
  ),
  Exercise(
    name: 'Paravatasana',
    instructions: [
      'Start by standing with your feet hip-width apart and your arms at your sides.',
      'Inhale deeply and raise your arms overhead, palms facing each other.',
      'Extend through your fingertips while keeping your shoulders relaxed.',
      'Engage your thigh muscles and lengthen your spine.',
      'Tilt your pelvis slightly forward to ensure your tailbone is pointing toward the floor.',
      'Hold the pose for several breaths, maintaining a tall, elongated posture.'
    ],
    image: "assets/images/parvatasana.jpg",
    gif: 'assets/images/pull_up.gif',
    trackedKeypoint: kKeypointDict['left_wrist'] as int, // You may need to adjust this based on tracking requirements
    trackingDirection: 1, // You may need to adjust this based on tracking requirements
    fullRepPosition: true, // Adjust as needed
    formCorrectnessModel: 'assets/models/paravatasana_v2.tflite', // You may need to create or acquire a relevant model
    targetedMuscles: ['Core', 'Legs', 'Back'],
    cameraInstructions: [
      "For this exercise, you need to place your phone in a portrait orientation.",
      "While exercising, your phone needs to be in a stable position (i.e. not move).",
      "Your phone's camera should be able to view your entire body's anterior, specially your nose, since we use it to track your reps.",
      "Start a warmup for 15 seconds. This is necessary for our AI to calculate some statistics off your body.",
      "Once you're done with your warmup, you should be able to start your workout.",
      "Once you have started a set, you should perform the required number of reps.",
      "When you're done, go back to your phone and start your rest period.",
      "If you want to, you can always just finish your set early and take your rest. Remember, exercise is supposed to be fun!",
    ],
    correctionAdvice: [
      'Ensure your feet are firmly grounded and evenly distributing your weight.',
      'Engage your core muscles to maintain stability.',
      'Keep your spine straight and elongated.',
      'Relax your neck and gaze straight ahead.',
    ],
  ),
];

/// MoveNet Keypoints constants
const Map<String, int> kKeypointDict = {
  'nose': 0,
  'left_eye': 1,
  'right_eye': 2,
  'left_ear': 3,
  'right_ear': 4,
  'left_shoulder': 5,
  'right_shoulder': 6,
  'left_elbow': 7,
  'right_elbow': 8,
  'left_wrist': 9,
  'right_wrist': 10,
  'left_hip': 11,
  'right_hip': 12,
  'left_knee': 13,
  'right_knee': 14,
  'left_ankle': 15,
  'right_ankle': 16,
};
