# Sentence
SimpleSentence = IndenpendentClause         #P937 
ComplexSentence = IndenpendentClause (DependentWord DenpendentClause)+ 
    DependentWord = SubordinatingConjunction | RelativePronoun |...
    SubordinatingConjunction = when | where | ...
    RelativePronoun = whom | ...
* TODO IndenpendentClause不一定在句首
1. IndenpendentClause也叫做main clause
2. IndenpendentClause必须包含完整的逻辑
3. DenpendentClause也叫做subordinate clauses
4. DenpendentClause依赖IndenpendentClause的逻辑

CompoundSentence = SimpleSentence (SentenceConjunction SimpleSentence)+
    SentenceConjunction = , CoordinatingConjunction | ; ConjunctiveAdverb [,] | ;
        CoordinatingConjunction = and | but | ...
        ConjunctiveAdverb = as a result | therefore | ...

CompoundComplexSentence = ComplexSentence (ComplexSentence | SimpleSentence)+

# Clause
Clause = [PredicateP1] （Subject ｜ CompoundSubject） PredicateP2  #P913
    PredicateP1 = AdverbialModifier
    PredicateP2 = 
        FiniteVerb [Object] [Modifier] [Complement]
        FiniteAuxiliaryVerb Participle [Object] [Modifier] [Complement]

* TODO 不同于CompleteSentence, clause in imperative sentence and non-finite clauses不遵守以上规则

# Phrase
Phrase = (Determiner| Modifier | Complement)+ TheWordToBeDescribed
"The bright red car is mine." 
                    -------- verb phrase.
     ----------  ajective phrase. 'bright' is a modifier discribe 'red'
 ------------------- noun phrase. 'the' is a determiner describe 'car'



# Subject
Subject = [Determiner] [Modifier] (Noun | Pronoun | PhraseOfNounOrPronoun | Gerund)   #P817
CompoundSubject = 
    Subject CoordinatingConjunction Subject
    Subject, (Subject,)+ CoordinatingConjunction Subject

# Predicate 
PredicateP2 = 
    PredicateAction CoordinatingConjunction PredicateAction  #P826
    PredicateAction, (PredicateAction,)+ CoordinatingConjunction PredicateAction
PredicateAction = 
    FiniteVerb
    FiniteVerbPhrase 
    FiniteAuxiliaryVerb (Participle | Object) 
FiniteVerbPhrase = FiniteVerb [Object] [Modifier]

FiniteVerb = VerbBaseForm | VerbPastTenseForm | VerbThirdPersonSingular | (is | am | are) #P830
NonFiniteVerb = Infinitive | Gerund | Participle
Infinitive = to VerbBaseForm


# Modifier
Modifier = Adjective | Adverb | AdverbialPhrase
1. Adjunct: modifier that provides no essential information
2. Complement: modifier that provides essential information #812



 #837
 #860



# Complement
part of predicate
Complement = Object | ObjectComplement | AdjectiveComplement | AdverbialComplement | SubjectComplement
AdjectiveComplement = PrepositionalPhrase | Infinitive | InfinitivePhrase | NounClause
SubjectComplemenet = PredicateNoun | PredicatePronoun | PredicativeAdjective

