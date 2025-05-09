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
    medtype: 'tablet',
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
      medtype: 'injection',
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
      medtype: 'tablet',
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
      medtype: 'inhalation',
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
      medtype: 'injection',
      brand: 'Adenocard',
      quantity: 10,
      stock: 10.0,
      uses: 'Management of supraventricular tachycardia (SVT)',
      sideEffects: 'Flushing, chest pain, shortness of breath',
      ingredients: 'Adenosine 3 mg/mL in 2 mL vial',
      directions: 'Administer as IV push rapidly as directed by healthcare provider',
      warnings: 'Monitor for signs of arrhythmia and bradycardia during administration'
  ),

  Medicine(
      name: 'Epinephrine (Adrenaline)',
      medtype: 'injection',
      brand: 'Adrenalin',
      quantity: 10,
      stock: 8.0,
      uses: 'Treatment of anaphylaxis, cardiac arrest',
      sideEffects: 'Palpitations, anxiety, headache',
      ingredients: 'Epinephrine 1 mg/mL (as Hydrochloride) in 1 mL ampul',
      directions: 'Administer via IV, IM, or SC as prescribed',
      warnings: 'Use with caution in patients with cardiovascular diseases'
  ),

  Medicine(
      name: 'Albendazole',
      medtype: 'tablet',
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
      medtype: 'tablet',
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
      medtype: 'injection',
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
      medtype: 'injection',
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
      medtype: 'injection',
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
      medtype: 'tablet',
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
      medtype: 'tablet',
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
      medtype: 'tablet',
      brand: 'Varibar',
      quantity: 1,
      stock: 1.0,
      uses: 'Used for X-ray contrast imaging',
      sideEffects: 'Constipation, nausea',
      ingredients: 'Barium sulfate (340 g per pouch)',
      directions: 'Suspend in water and ingest as directed for X-ray imaging',
      warnings: 'Avoid in patients with known gastrointestinal perforation or obstruction'
  ),

  Medicine(
      name: 'Betaxolol',
      medtype: 'drops',
      brand: 'Betoptic',
      quantity: 1,
      stock: 1.0,
      uses: 'Treatment of elevated intraocular pressure in glaucoma',
      sideEffects: 'Eye irritation, blurred vision, dry eyes',
      ingredients: 'Betaxolol hydrochloride 0.25%',
      directions: 'Instill one drop in the affected eye(s) twice daily',
      warnings: 'Use with caution in patients with bradycardia or heart block'
  ),

  Medicine(
      name: 'Brimonidine',
      medtype: 'drops',
      brand: 'Alphagan',
      quantity: 1,
      stock: 1.0,
      uses: 'Lowering intraocular pressure in glaucoma',
      sideEffects: 'Burning sensation in eyes, dry mouth, headache',
      ingredients: 'Brimonidine tartrate 0.15%',
      directions: 'Instill one drop in the affected eye(s) twice daily',
      warnings: 'Caution in patients with cardiovascular disorders'
  ),

  Medicine(
      name: 'Brinzolamide',
      medtype: 'drops',
      brand: 'Azopt',
      quantity: 1,
      stock: 1.0,
      uses: 'Treatment of elevated intraocular pressure in glaucoma',
      sideEffects: 'Eye irritation, blurred vision, taste alteration',
      ingredients: 'Brinzolamide 1%',
      directions: 'Instill one drop in the affected eye(s) twice daily',
      warnings: 'Use with caution in patients with renal impairment'
  ),

  Medicine(
      name: 'Budesonide',
      medtype: 'inhalation',
      brand: 'Pulmicort',
      quantity: 60,
      stock: 55.0,
      uses: 'Treatment of asthma and chronic obstructive pulmonary disease (COPD)',
      sideEffects: 'Cough, hoarseness, throat irritation',
      ingredients: 'Budesonide 250 mcg/mL in 2 mL unit dose',
      directions: 'Inhale one unit dose as prescribed, usually twice daily',
      warnings: 'Rinse mouth after use to avoid fungal infections'
  ),

  Medicine(
      name: 'Budesonide + Formoterol',
      medtype: 'inhalation',
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
      medtype: 'tablet',
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
      medtype: 'drops',
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
      medtype: 'patch',
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
      medtype: 'capsule',
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
      medtype: 'capsule',
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
      medtype: 'patch',
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
      medtype: 'patch',
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
      medtype: 'capsule',
      brand: 'Prozac',
      quantity: 30,
      stock: 30.0,
      uses: 'Treatment of depression, anxiety, and OCD',
      sideEffects: 'Nausea, headache, insomnia, sexual dysfunction',
      ingredients: 'Fluoxetine 20 mg',
      directions: 'Take 1 capsule daily, usually in the morning',
      warnings: 'May increase risk of suicidal thoughts; monitor mood changes'
  ),
  // Add more medicines here...
];
