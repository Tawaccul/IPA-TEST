// class Levels { 
//   final int id;
//   final Words words; 
//   final Others others;

//   Levels(this.id, this.words, this.others,);

 

//   get image => null;
// }

// class Words {
//     final int id; 
//     final List<Map<int, String>> arabicWord; 
//     final Translate translate;
//     final List<Map<int, String>> letters;
//     final String sentence;
//     final Sentence sentenceTranslate;
//     final List<Map<int, String>> image;
//     final String audio;

//     Words(this.id, this.arabicWord, this.translate, this.sentence, this.image, this.audio, this.sentenceTranslate, this.letters);
// }

// class Translate {
//     final int id; 
//     final List<Map<int, String>> russian; 
//     final List<Map<int, String>> english;

//     Translate(this.id, this.russian, this.english);
// }


// class Sentence {
//     final int id;
//     final String sentenceRussian;
//     final String sentenceEnglish;

//     Sentence(this.id, this.sentenceRussian, this.sentenceEnglish);
// }

// class Others {
//     final int id;
//     final List<Map<int, String>> button;
//     final String image;

//     Others(this.id, this.button, this.image);
// }

// class DataBase { 

//    final List<Levels> levels = [
//          Levels(1, 
//                 Words( 
//                     1, 
//                     [{1 :'الرَّحْمَٰنِ'}, { 2:'الرَّحِيمِ'}, { 3 :'مَالِكِ'},{ 4: 'يَوْمِ' }],
//                     Translate(1, 
//                      [{1: 'Милостивому'}, { 2: 'Милосердному'}, { 3: 'Царю'}, { 4: 'Дня Воздаяния'}],
//                      [{1: 'The Most Merciful'}, { 2: 'The Most Gracious'}, { 3: 'The Day of the Judgment'}, { 4: 'The Master'}],
//                     ), 
//                     ' الرَّحْمَٰنِ الرَّحِيمِ مَالِكِ يَوْمِ الدِّينِ',
//                     [{1 : 'https://storage.googleapis.com/glaze-ecom.appspot.com/images/tcSBfqVpR/thumbs/464.png'},
//                      {2 : 'https://storage.googleapis.com/glaze-ecom.appspot.com/images/mwMLHSBX9/thumbs/464.png'},
//                      {3 : 'https://storage.googleapis.com/glaze-ecom.appspot.com/images/vlBa0txaj/thumbs/464.png'},
//                      {4 : 'https://storage.googleapis.com/glaze-ecom.appspot.com/images/qlEEZvejP/thumbs/464.png'}
//                     ], 
//                     'assets/audio/level1.mp3',
//                     Sentence(1,
//                     ' Милостивому, Милосердному. Царю Дня Воздаяния!',
//                     '	The Master of the Day of the Judgment. The Most Gracious, the Most Merciful',
//                     ),
//                     [{}],
//                     ), 
//                     Others(1, 
//                           [
//                             {1: 'Милосердному'},
//                             {2: 'Милостивому'},
//                             {3: 'Дня Воздаяния'},
//                             {4: 'Царю'},
//                             {5: 'Богу'},
//                             {6: 'Раю'},
//                             {7: 'Ангелы'},
//                             {8: 'Имран'},
//                           ]
//                     , ''),
                     
//                     ), 
//          Levels(2, 
//                 Words( 
//                     2, 
//                     [{1 :'قُلْ'}, { 2:'أَعُوذُ'}, { 3 :'بِرَبِّ'},{ 4: 'النَّاسِ'}],
//                     Translate(1, 
//                      [{1: 'Скажи'}, { 2: '"Я обращаюсь за защитой'}, { 3: 'к Господу'}, { 4: 'людей'}],
//                      [{1: 'The Most Merciful'}, { 2: 'The Most Gracious'}, { 3: 'The Day of the Judgment'}, { 4: 'The Master'}],
//                     ), 
//                     ' قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
//                     [{1 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'},
//                      {2 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'},
//                      {3 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'},
//                      {4 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'}
//                     ], 
//                     'assets/audio/level1.mp3',
//                     Sentence(2,
//                     'Скажи "Я обращаюсь за защитой к Господу людей',
//                     'Say, "I seek refuge in the Lord	of mankind',
//                     ),
//                     [{}]
//                     ), 
//                     Others(2, 
//                           [
//                             {1: 'Скажи'},
//                             {2: '"Я обращаюсь за защитой'},
//                             {3: 'к Господу'},
//                             {4: 'людей'},
//                             {5: 'Дерево'},
//                             {6: 'Отроки'},
//                             {7: 'Пороки'},
//                             {8: 'Правда'},
//                           ]
//                     , ''),
                     
//                     ), 

//             Levels(3, 
//                 Words( 
//                     3, 
//                     [{1 :'قُلْ'}, { 2:'أَعُوذُ'}, { 3 :'بِرَبِّ'},{ 4: 'النَّاسِ'}],
//                     Translate(1, 
//                      [{1: 'Скажи'}, { 2: '"Я обращаюсь за защитой'}, { 3: 'к Господу'}, { 4: 'людей'}],
//                      [{1: 'The Most Merciful'}, { 2: 'The Most Gracious'}, { 3: 'The Day of the Judgment'}, { 4: 'The Master'}],
//                     ), 
//                     ' قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
//                     [{1 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'},
//                      {2 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'},
//                      {3 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'},
//                      {4 : 'https://assets-global.website-files.com/614057d4b4c88103e52f7176/6141dff3abbd8a5ad84c92a8_img1.jpg'}
//                     ], 
//                     'assets/audio/level1.mp3',
//                     Sentence(3,
//                     'Скажи "Я обращаюсь за защитой к Господу людей',
//                     'Say, "I seek refuge in the Lord	of mankind',
//                     ),
//                     [{}]
//                     ), 
//                     Others(3, 
//                           [
//                             {1: 'Скажи'},
//                             {2: '"Я обращаюсь за защитой'},
//                             {3: 'к Господу'},
//                             {4: 'людей'},
//                             {5: 'Дерево'},
//                             {6: 'Отроки'},
//                             {7: 'Пороки'},
//                             {8: 'Правда'},
//                           ]
//                     , ''),
                     
//                     ),
                           
//    ];
// }




