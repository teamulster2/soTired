import 'package:so_tired/ui/models/questionnaire.dart';

/// This constant defined the first sample QuestionnaireObjects
final List<QuestionnaireObject> questions = <QuestionnaireObject>[
  QuestionnaireObject(
      'Have you felt fatigued during the past month? It does not matter if the fatigue is physical (muscular) or mental. If you recently experienced something unusual (for example an accident or short illness) you should try to disregard it when assessing your fatigue.',
      <String>[
        'I do not feel fatigued at all. (No abnormal fatigue, do not need to rest more than usual).',
        'I feel fatigued several times every day but I feel more alert after a rest.',
        'I feel fatigued for most of the day and taking a rest has little or no effect.',
        'I feel fatigued all the time and taking a rest makes no difference.'
      ]),
  QuestionnaireObject(
      'Do you find it difficult to start things? Do you experience resistance or a lack of initiative when you have to start something, no matter whether it is a new task or part of your everyday activities?',
      <String>[
        'I have no difficulty starting things.',
        'I find it more difficult starting things than I used to. I’d rather do it some other time.',
        'It takes a great effort to start things. This applies to everyday activities such as getting out of bed, washing my self and eating.',
        'I can’t do the simplest of everyday tasks (eating, getting dressed). I need help with everything.'
      ]),
  QuestionnaireObject(
      'Does your brain become fatigued quickly when you have to think hard? Do you become mentally fatigued from things such as reading, watching TV or taking part in a conversation with several people? Do you have to take breaks or change to another activity?',
      <String>[
        'I can manage in the same way as usual. My ability for sustained mental effort is not reduced.',
        'I become fatigued quickly but am still able to make the same mental effort as before',
        'I become fatigued quickly and have to take a break or do something else more often than before',
        'I become fatigued so quickly that I can do nothing or have to abandon everything after a short period (approx. five minutes)'
      ]),
  QuestionnaireObject(
      'How long do you need to recover after you have worked “until you drop” or are no longer able to concentrate on what you are doing?',
      <String>[
        'I need to rest for less than an hour before continuing whatever I am doing.',
        'I need to rest for more than an hour but do not require a night’s sleep.',
        'I need a night’s sleep before I can continue whatever I am doing.',
        'I need several days rest in order to recover.'
      ]),
  QuestionnaireObject(
      'Do you find it difficult to gather your thoughts and concentrate? ',
      <String>[
        'I can concentrate as usual.',
        'I sometimes lose concentration, for example when reading or watching TV.',
        'I find it so difficult to concentrate that I have problems, for example reading a newspaper or taking part in a conversation with a group of people.',
        'I always have such difficulty concentrating that it is almost impossible to do anything.'
      ])
];
