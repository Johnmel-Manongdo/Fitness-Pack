import 'package:fitness_pack/screens/Training/model/exercise_set.dart';
import 'package:flutter/material.dart';

import 'exercise.dart';

final exerciseSets = [
  ExerciseSet(
    name: 'Upper Body',
    exercises: upperBodyEasy,
    imageUrl: 'assets/images/workout1.png',
    exerciseType: ExerciseType.low,
    color: Colors.blue.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Back',
    exercises: backEasy,
    imageUrl: 'assets/images/workout2.png',
    exerciseType: ExerciseType.low,
    color: Colors.green.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Butt and Leg',
    exercises: buttLegEasy,
    imageUrl: 'assets/images/workout6.png',
    exerciseType: ExerciseType.low,
    color: Colors.orange.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Belly',
    exercises: bellyEasy,
    imageUrl: 'assets/images/workout3.png',
    exerciseType: ExerciseType.low,
    color: Colors.purple.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Upper Body',
    exercises: upperBodyMedium,
    imageUrl: 'assets/images/workout7.png',
    exerciseType: ExerciseType.mid,
    color: Colors.pink.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Back',
    exercises: backMedium,
    imageUrl: 'assets/images/workout7.png',
    exerciseType: ExerciseType.mid,
    color: Colors.yellowAccent.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Butt and Leg',
    exercises: buttLegMedium,
    imageUrl: 'assets/images/workout6.png',
    exerciseType: ExerciseType.mid,
    color: Colors.orange.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Belly',
    exercises: bellyMedium,
    imageUrl: 'assets/images/workout8.png',
    exerciseType: ExerciseType.mid,
    color: Colors.purple.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Upper Body',
    exercises: upperBodyHard,
    imageUrl: 'assets/images/workout10.png',
    exerciseType: ExerciseType.hard,
    color: Colors.teal.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Back',
    exercises: backHard,
    imageUrl: 'assets/images/workout1.png',
    exerciseType: ExerciseType.hard,
    color: Colors.orange.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Butt and Leg',
    exercises: buttLegHard,
    imageUrl: 'assets/images/workout1.png',
    exerciseType: ExerciseType.hard,
    color: Colors.blue.shade100.withOpacity(0.6),
  ),
  ExerciseSet(
    name: 'Belly',
    exercises: bellyHard,
    imageUrl: 'assets/images/workout11.png',
    exerciseType: ExerciseType.hard,
    color: Colors.teal.shade100.withOpacity(0.6),
  ),
];
