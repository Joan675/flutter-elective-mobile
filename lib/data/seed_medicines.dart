import '../models/medicine.dart';

List<Medicine> seedMedicines = [
  Medicine(
    name: 'Lisinopril',
    medtype: 'Capsule',
    brand: 'LisiTab',
    quantity: 90,
    stock: 87.0,
    uses: 'High blood pressure',
    sideEffects: 'Cough, dizziness',
    ingredients: 'Lisinopril',
    directions: 'Once daily in morning',
    warnings: 'Avoid potassium supplements',
  ),
  Medicine(
      name: 'Abacavir',
      medtype: 'Tablet',
      brand: 'Ziagen',
      quantity: 60,
      stock: 57.0,
      uses: 'Treatment of HIV-1 infection',
      sideEffects: 'Hypersensitivity reaction, nausea, headache',
      ingredients: 'Abacavir sulfate 300 mg',
      directions: 'Take one tablet twice daily or as directed by a healthcare provider',
      warnings: 'Screen for HLA-B*5701 allele before starting due to risk of hypersensitivity reaction'
  ),

  Medicine(
      name: 'Acetated Ringer\'s Solution',
      medtype: 'Injections',
      brand: 'Generic',
      quantity: 1,
      stock: 1.0,
      uses: 'Fluid and electrolyte replacement therapy',
      sideEffects: 'Possible fluid overload, electrolyte imbalance',
      ingredients: 'Na+ 130 mmol/L, K+ 4 mmol/L, Ca++ 3 mmol/L, Cl- 109 mmol/L',
      directions: 'Administer via IV infusion as prescribed',
      warnings: 'Monitor fluid balance and electrolytes during use'
  ),

  Medicine(
      name: 'Acetazolamide',
      medtype: 'Tablet',
      brand: 'Diamox',
      quantity: 100,
      stock: 95.0,
      uses: 'Glaucoma, epilepsy, altitude sickness, edema',
      sideEffects: 'Tingling, loss of appetite, electrolyte imbalance',
      ingredients: 'Acetazolamide 250 mg',
      directions: 'Take orally as prescribed, usually once or twice daily',
      warnings: 'Use with caution in kidney or liver disease'
  ),

  Medicine(
      name: 'Acetylcysteine',
      medtype: 'Inhalers',
      brand: 'Fluimucil Inhalant',
      quantity: 5,
      stock: 5.0,
      uses: 'Mucolytic therapy in respiratory conditions',
      sideEffects: 'Bronchospasm, unpleasant odor',
      ingredients: 'Acetylcysteine 100 mg/mL solution in 3 mL ampule',
      directions: 'Inhale via nebulizer as directed',
      warnings: 'Use with caution in asthma patients due to bronchospasm risk'
  ),

  Medicine(
      name: 'Adenosine',
      medtype: 'Injections',
      brand: 'Adenocard',
      quantity: 10,
      stock: 10.0,
      uses: 'Management of supraventricular tachycardia (SVT),',
      sideEffects: 'Flushing, chest pain, shortness of breath',
      ingredients: 'Adenosine 3 mg/mL in 2 mL vial',
      directions: 'Administer as IV push rapidly as directed by healthcare provider',
      warnings: 'Monitor for signs of arrhythmia and bradycardia during administration'
  ),

  Medicine(
      name: 'Epinephrine (Adrenaline),',
      medtype: 'Injections',
      brand: 'Adrenalin',
      quantity: 10,
      stock: 8.0,
      uses: 'Treatment of anaphylaxis, cardiac arrest',
      sideEffects: 'Palpitations, anxiety, headache',
      ingredients: 'Epinephrine 1 mg/mL (as Hydrochloride), in 1 mL ampul',
      directions: 'Administer via IV, IM, or SC as prescribed',
      warnings: 'Use with caution in patients with cardiovascular diseases'
  ),

  Medicine(
      name: 'Albendazole',
      medtype: 'Tablet',
      brand: 'Albenza',
      quantity: 60,
      stock: 58.0,
      uses: 'Treatment of parasitic infections like roundworm, hookworm, tapeworm',
      sideEffects: 'Abdominal pain, headache, nausea',
      ingredients: 'Albendazole 200 mg/5 mL suspension',
      directions: 'Take orally as prescribed, usually once or twice daily',
      warnings: 'Not recommended during pregnancy or in children under 2 years old'
  ),

  Medicine(
      name: 'Aluminum + Magnesium',
      medtype: 'Tablet',
      brand: 'Maalox',
      quantity: 60,
      stock: 55.0,
      uses: 'Relief of heartburn, indigestion',
      sideEffects: 'Diarrhea, constipation',
      ingredients: 'Aluminum Hydroxide 225 mg + Magnesium Hydroxide 200 mg per 5 mL',
      directions: 'Take orally as needed for symptoms, up to 4 times daily',
      warnings: 'Use with caution in patients with kidney disease'
  ),

  Medicine(
      name: 'Amikacin',
      medtype: 'Injections',
      brand: 'Amikin',
      quantity: 20,
      stock: 18.0,
      uses: 'Treatment of serious infections caused by Gram-negative bacteria',
      sideEffects: 'Nephrotoxicity, ototoxicity',
      ingredients: 'Amikacin sulfate 50 mg/mL in 2 mL vial',
      directions: 'Administer via IV or IM as directed by healthcare provider',
      warnings: 'Monitor renal function during therapy'
  ),

  Medicine(
      name: 'Anti-rabies serum',
      medtype: 'Injections',
      brand: 'RabIg',
      quantity: 5,
      stock: 5.0,
      uses: 'Post-exposure prophylaxis for rabies',
      sideEffects: 'Pain at injection site, allergic reactions',
      ingredients: 'Anti-rabies serum 200 IU/mL in 5 mL vial',
      directions: 'Administer via IM injection as directed by healthcare provider',
      warnings: 'Monitor for signs of an allergic reaction during and after administration'
  ),

  Medicine(
      name: 'Anti-tetanus serum',
      medtype: 'Injections',
      brand: 'Tetanus Immune Globulin',
      quantity: 5,
      stock: 5.0,
      uses: 'Prevention and treatment of tetanus after exposure',
      sideEffects: 'Pain at injection site, allergic reactions',
      ingredients: 'Anti-tetanus serum 1500 IU/mL in 1.5 mL ampul',
      directions: 'Administer via IM injection as directed by healthcare provider',
      warnings: 'Monitor for signs of an allergic reaction'
  ),

  Medicine(
      name: 'Azithromycin',
      medtype: 'Tablet',
      brand: 'Zithromax',
      quantity: 60,
      stock: 58.0,
      uses: 'Treatment of bacterial infections, including respiratory and skin infections',
      sideEffects: 'Nausea, diarrhea, abdominal pain',
      ingredients: 'Azithromycin 200 mg/5 mL powder for suspension',
      directions: 'Mix with water and take orally as prescribed',
      warnings: 'Use with caution in patients with liver disease or arrhythmias'
  ),

  Medicine(
      name: 'Baclofen',
      medtype: 'Tablet',
      brand: 'Lioresal',
      quantity: 30,
      stock: 28.0,
      uses: 'Muscle relaxant for spasticity in conditions like multiple sclerosis',
      sideEffects: 'Drowsiness, dizziness, weakness',
      ingredients: 'Baclofen 10 mg',
      directions: 'Take orally as prescribed, usually 3 times daily',
      warnings: 'Use with caution in patients with renal impairment'
  ),

  Medicine(
      name: 'Barium',
      medtype: 'Tablet',
      brand: 'Varibar',
      quantity: 1,
      stock: 1.0,
      uses: 'Used for X-ray contrast imaging',
      sideEffects: 'Constipation, nausea',
      ingredients: 'Barium sulfate (340 g per pouch),',
      directions: 'Suspend in water and ingest as directed for X-ray imaging',
      warnings: 'Avoid in patients with known gastrointestinal perforation or obstruction'
  ),

  Medicine(
      name: 'Betaxolol',
      medtype: 'Drops',
      brand: 'Betoptic',
      quantity: 1,
      stock: 1.0,
      uses: 'Treatment of elevated intraocular pressure in glaucoma',
      sideEffects: 'Eye irritation, blurred vision, dry eyes',
      ingredients: 'Betaxolol hydrochloride 0.25%',
      directions: 'Instill one drop in the affected eye(s), twice daily',
      warnings: 'Use with caution in patients with bradycardia or heart block'
  ),

  Medicine(
      name: 'Brimonidine',
      medtype: 'Drops',
      brand: 'Alphagan',
      quantity: 1,
      stock: 1.0,
      uses: 'Lowering intraocular pressure in glaucoma',
      sideEffects: 'Burning sensation in eyes, dry mouth, headache',
      ingredients: 'Brimonidine tartrate 0.15%',
      directions: 'Instill one drop in the affected eye(s), twice daily',
      warnings: 'Caution in patients with cardiovascular disorders'
  ),

  Medicine(
      name: 'Brinzolamide',
      medtype: 'Drops',
      brand: 'Azopt',
      quantity: 1,
      stock: 1.0,
      uses: 'Treatment of elevated intraocular pressure in glaucoma',
      sideEffects: 'Eye irritation, blurred vision, taste alteration',
      ingredients: 'Brinzolamide 1%',
      directions: 'Instill one drop in the affected eye(s), twice daily',
      warnings: 'Use with caution in patients with renal impairment'
  ),

  Medicine(
      name: 'Budesonide',
      medtype: 'Inhalers',
      brand: 'Pulmicort',
      quantity: 60,
      stock: 55.0,
      uses: 'Treatment of asthma and chronic obstructive pulmonary disease (COPD),',
      sideEffects: 'Cough, hoarseness, throat irritation',
      ingredients: 'Budesonide 250 mcg/mL in 2 mL unit dose',
      directions: 'Inhale one unit dose as prescribed, usually twice daily',
      warnings: 'Rinse mouth after use to avoid fungal infections'
  ),

  Medicine(
      name: 'Budesonide + Formoterol',
      medtype: 'Inhalers',
      brand: 'Symbicort',
      quantity: 120,
      stock: 110.0,
      uses: 'Treatment of asthma and COPD',
      sideEffects: 'Tremor, palpitations, throat irritation',
      ingredients: 'Budesonide 80 mcg + Formoterol 4.5 mcg per dose',
      directions: 'Inhale one puff twice daily as prescribed',
      warnings: 'Monitor for signs of adrenal suppression and infections'
  ),

  Medicine(
      name: 'Bumetanide',
      medtype: 'Tablet',
      brand: 'Bumex',
      quantity: 30,
      stock: 28.0,
      uses: 'Treatment of edema in heart failure or renal disease',
      sideEffects: 'Hypokalemia, dehydration, dizziness',
      ingredients: 'Bumetanide 1 mg',
      directions: 'Take orally once or twice daily as prescribed',
      warnings: 'Monitor electrolytes and renal function during therapy'
  ),

  Medicine(
      name: 'Carbachol',
      medtype: 'Drops',
      brand: 'Miostat',
      quantity: 1,
      stock: 1.0,
      uses: 'Induction of miosis during ocular surgery, treatment of glaucoma',
      sideEffects: 'Blurred vision, eye irritation, headache',
      ingredients: 'Carbachol 0.01% intraocular solution',
      directions: 'Instill as directed during surgery or for glaucoma treatment',
      warnings: 'Monitor for signs of ocular pressure changes'
  ),

  Medicine(
      name: 'Fentanyl',
      medtype: 'Patches',
      brand: 'Duragesic',
      quantity: 1,
      stock: 1.0,
      uses: 'Pain management for severe chronic pain, opioid analgesic',
      sideEffects: 'Nausea, dizziness, drowsiness, constipation',
      ingredients: 'Fentanyl 25 mcg/hr',
      directions: 'Apply one patch to the skin every 72 hours',
      warnings: 'Do not cut or expose to heat; opioid-related risks including respiratory depression'
  ),

  Medicine(
      name: 'Ibuprofen',
      medtype: 'Capsule',
      brand: 'Advil',
      quantity: 20,
      stock: 20.0,
      uses: 'Pain relief, anti-inflammatory, antipyretic',
      sideEffects: 'Upset stomach, dizziness, headache',
      ingredients: 'Ibuprofen 200 mg',
      directions: 'Take 1-2 capsules every 4-6 hours as needed for pain',
      warnings: 'Use with caution in patients with gastrointestinal or kidney problems'
  ),

  Medicine(
      name: 'Amoxicillin',
      medtype: 'Capsule',
      brand: 'Amoxil',
      quantity: 30,
      stock: 30.0,
      uses: 'Antibiotic for bacterial infections such as respiratory, skin, and urinary tract infections',
      sideEffects: 'Diarrhea, nausea, rash',
      ingredients: 'Amoxicillin 500 mg',
      directions: 'Take 1 capsule every 8 hours, usually for 7-10 days',
      warnings: 'Allergy to penicillins; use with caution in renal dysfunction'
  ),

  Medicine(
      name: 'Clonidine',
      medtype: 'Patches',
      brand: 'Catapres-TTS',
      quantity: 1,
      stock: 1.0,
      uses: 'Treatment of high blood pressure',
      sideEffects: 'Dry mouth, drowsiness, constipation',
      ingredients: 'Clonidine 0.1 mg/24 hr',
      directions: 'Apply one patch to the skin once every 7 days',
      warnings: 'Do not discontinue suddenly, may cause rebound hypertension; monitor for sedation'
  ),

  Medicine(
      name: 'Buprenorphine',
      medtype: 'Patches',
      brand: 'Butrans',
      quantity: 1,
      stock: 1.0,
      uses: 'Pain management for chronic pain and opioid dependence',
      sideEffects: 'Drowsiness, nausea, constipation',
      ingredients: 'Buprenorphine 5 mcg/hr',
      directions: 'Apply one patch to the skin every 7 days',
      warnings: 'Do not use with other central nervous system depressants; monitor for signs of respiratory depression'
  ),

  Medicine(
      name: 'Fluoxetine',
      medtype: 'Capsule',
      brand: 'Prozac',
      quantity: 30,
      stock: 30.0,
      uses: 'Treatment of depression, anxiety, and OCD',
      sideEffects: 'Nausea, headache, insomnia, sexual dysfunction',
      ingredients: 'Fluoxetine 20 mg',
      directions: 'Take 1 capsule daily, usually in the morning',
      warnings: 'May increase risk of suicidal thoughts; monitor mood changes'
  ),

  Medicine(
    name: 'Paracetamol Syrup',
    medtype: 'Liquid',
    brand: 'Biogesic',
    quantity: 1,
    stock: 1.0,
    uses: 'Reduces fever and relieves mild to moderate pain',
    sideEffects: 'Nausea, allergic reactions, liver issues with overdose',
    ingredients: 'Paracetamol 250mg/5ml',
    directions: 'Take 5ml every 4–6 hours as needed, not exceeding 4 doses in 24 hours',
    warnings: 'Do not exceed recommended dose; consult doctor for use in children under 2 years'
  ),
  Medicine(
    name: 'Ambroxol Syrup',
    medtype: 'Liquid',
    brand: 'Mucosolvan',
    quantity: 1,
    stock: 1.0,
    uses: 'Relieves cough with phlegm by thinning mucus',
    sideEffects: 'Gastrointestinal discomfort, headache, allergic rash',
    ingredients: 'Ambroxol Hydrochloride 30mg/5ml',
    directions: 'Take 5ml two to three times daily after meals',
    warnings: 'Use with caution in patients with peptic ulcer or severe liver disease'
  ),
  Medicine(
    name: 'Salbutamol Syrup',
    medtype: 'Liquid',
    brand: 'Ventolin',
    quantity: 1,
    stock: 1.0,
    uses: 'Relieves bronchospasm in asthma and other airway diseases',
    sideEffects: 'Tremor, headache, increased heart rate, nervousness',
    ingredients: 'Salbutamol Sulfate 2mg/5ml',
    directions: '5ml three times a day or as prescribed by physician',
    warnings: 'Use with caution in patients with cardiovascular disorders'
  ),
  Medicine(
    name: 'Ibuprofen Suspension',
    medtype: 'liquid',
    brand: 'Advil',
    quantity: 1,
    stock: 1.0,
    uses: 'Relieves pain, fever, and inflammation',
    sideEffects: 'Nausea, dizziness, gastrointestinal upset',
    ingredients: 'Ibuprofen 100mg/5ml',
    directions: 'Take 5ml every 6–8 hours, not exceeding 4 doses per day',
    warnings: 'Avoid use in patients with peptic ulcer or renal impairment'
  ),
  Medicine(
    name: 'Cefalexin Suspension',
    medtype: 'Liquid',
    brand: 'Keflex',
    quantity: 1,
    stock: 1.0,
    uses: 'Treats bacterial infections like tonsillitis, skin infections, and UTIs',
    sideEffects: 'Diarrhea, nausea, allergic reactions',
    ingredients: 'Cefalexin 250mg/5ml',
    directions: '5ml every 8 hours for 7 to 10 days or as prescribed',
    warnings: 'Complete full course; inform physician if rash or allergy occurs'
  ),
  // Add more medicines here...
];
