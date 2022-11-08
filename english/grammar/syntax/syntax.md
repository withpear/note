# Sentence
SimpleSentence = IndenpendentClause                                           #P937 
TODO "Personally, I don’t believe it’s true."
ComplexSentence = IndenpendentClause (DependentWord DenpendentClause)+ 
DependentWord = SubordinatingConjunction | RelativePronoun | RelativeAdverb |...
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

当两个independent clause 同时出现时，后一个clause为adverb(ial) clause修饰前一个clause

CompoundComplexSentence = ComplexSentence (ComplexSentence | SimpleSentence)+

# Clause
Clause = [PredicateP1] （Subject ｜ CompoundSubject） PredicateP2                       #P813   P913
    PredicateP1 = AdverbialModifier
    PredicateP2 = 
        FiniteVerb [Object] [Modifier] [Complement]
        FiniteAuxiliaryVerb Participle [Object] [Modifier] [Complement]

* TODO 不同于CompleteSentence, clause in imperative sentence and non-finite clauses不遵守以上规则

# Phrase
Phrase = (Determiner| Modifier | Complement)+ TheWordToBeDescribed                      #P812
    "The bright red car is mine." 
                        -------- verb phrase.
         ---------               ajective phrase. 'bright' is a modifier discribe 'red'
    -------------------          noun phrase. 'the' is a determiner describe 'car'


# Subject
Subject = [Determiner] [Modifier] (Noun | Pronoun | PhraseOfNounOrPronoun | Gerund)     #P815  P817*
CompoundSubject =           #P829
    Subject CoordinatingConjunction Subject
    Subject, (Subject,)+ CoordinatingConjunction Subject

# Predicate 
PredicateP2 =                                                                           #P816 P826
    PredicateAction CoordinatingConjunction PredicateAction                             #P828
    PredicateAction, (PredicateAction,)+ CoordinatingConjunction PredicateAction
PredicateAction = 
    FiniteVerb
    FiniteVerbPhrase 
    FiniteAuxiliaryVerb (Participle | Object) 
FiniteVerbPhrase = FiniteVerb [Object] [Modifier]

FiniteVerb = VerbBaseForm | VerbPastTenseForm | VerbThirdPersonSingular | (is | am | are) #P830
NonFiniteVerb = Infinitive | Gerund | Participle
Infinitive = to VerbBaseForm

# Object
Object = Noun | Pronoun                                              #P838  P843*   
1. direct/indirect object can complete verb, it's called verb complement
2. object of prepositon can complete perposition, it's called prepositonal complement
3. only transitive verbs can take objects


# Modifier
Modifier = Adjective | Adverb | AdverbialPhrase                       #P812 P835 P860*
1. Adjunct: modifier that provides no essential information
2. Complement: modifier that provides essential information           #P812  好像不对 互斥关系
P860
P856    
Complement不一定是Modifier，比如 Object Complement的NounPhrase
Complement可能是Modifier，比如Object Complement的RelativeClause
Modifier可能不是Complement，如果它的信息不是必须要的话。如果Modifier的信息是必要的，那么它一定Complement




# Complement    #P833 P837 P847
1. Complement用来提供必要信息完成句子
2. 五种类型: object, object complement, adjective complemenet, adverbial complement, subject complement

## Object
VerbComplement = DirectObject [IndirectObject] #也有可能反过来          #P832* P838 P843*  
    "Please pass me the salt."
                 --           indirect object. 注意它不是 object complement，它只补足了verb
                    --------  direct object
                ------------- verb complement

PrepositionalComplement = PrepositionObject                           #P832* P838 P843*  
    "Your backpack is under the table."
                            ---------  obejct of preposition 
                            ---------  prepositional complement
                      ---------------  prepositional phrase   

## [Direct]ObjectComplement
[Direct]ObjectComplement =                                             #P833* P839 P851*
    NounOrNounPhrase
    AdjectiveOrAdjectivePhrase
    RelativeClause
    InfinitiveOrInfinitivePhrase
    GerundOrGerundPhrase

RelativeClause = DependentClauseStartingWithRelativePronounOrRelativeAdverb

1. ObjectComplement must follow the direct object
2. InfinitiveOrInfinitivePhrase describe an act that has not yet been done
3. GerundOrGerundPhrase describe what the direct object is or was doing
    "The committee elected him treasurer."
                           ---             direct obeject
                               ---------   noun, object complement. 注意它不是indirect object，它补足了object而不是verb
                    -------                factitive verb

    "All he wanted was to make his cute wife happy."
                                             -----  adjective, object complement
                                   ----             attributive adjective  
                               -------------        direct object

    "Do you know someone who can work the printer?"
                         ---                        relative pronoun
                         -------------------------  relative clause, aka, adjective clause. object complement
                 -------                            direct object        

    "I didn’t expect you to approve."
                     ---              direct object
                         -----------  infinitive. object complement

    "We came across him lying in the yard."
                    ---                     direct object
                        -----------------   gerund phrase. object complement

## Adjective[Phrase]Complement
Adjective[Phrase]Complement =                              #P833* P840 P855*
    PrepositionalPhrase
    InfinitiveOrInfinitivePhrase
    NounClause

    "He felt alone in the world."
        ----                       linking verb
             -----                 adjective
                   -------------   prepositionanl phrase, adjective complement
                      ----------   object of prepositon. prepositional complement

    "I'm very happy to know you!" 
              -----                adjective
                    ------------   inifitive phrase. adjective complement

    "We were a little curious why they decided to leave."
                      -------                              adjective
                              --------------------------   noun clause. adjective complement
## AdverbialComplement
AdverbialComplement = Adverbial                        #P833* P841 P858*
    Adverbial = Adverb | AdverbialNoun | AdverbialPhrase | AdverbialPhrase
1. If the verb is intransitive, the complement will appear directly after the verb; if the verb is transitive, the complement will appear after the verb’s direct object.
2. 注意词典里没有AdverbialNoun,它们只会写adverb

    "The teacher sent Tim home."
                          ----   adverbial noun. adverbial complement
   
    "Please put the book on the shelf."
                         ------------- adverbial phrase, adverbial prepositional phrase. adverbial complement
## SubjectComplement
SubjectComplement =                                 #P833* P841 P847*
    PredicateNoun[Phrase] 
    PredicatePronoun
    PredicativeAdjective
1. subject complement 必须在linking verb 后面

    "Love is a virtue."
          --             linking verb
             -           determiner
               -------   predicate noun
             ---------   subject complement

    "Tommy seems like a real bully." 
           -----                    linking verb
                 ----               preposition
                 ------------------ prepositional phrase
                 ??????????????????? TODO subject complement

    "Who is it?"
            --              predicate pronoun. subject complement
    "It's me."
          --                predicate pronoun. subject complement 
    "It was I who did this."  
            -               predicate pronoun. subject complement 
2. predicate pronoun 经常用做提问、回答和声明

    "You look nice."
         ----       linking verb
              ----  predicative adjective. subject complement

    "The cat is in the shed."
                -----------   prepositional phrase. predicative adjective. subject complement
                


# Infinitive P218
## as a Noun
* infinitive the as subject
"To dream requires incredible courage."
 --------                               subject

* infinitive as the subject complement
"Our aim is to improve."
            -----------  subject complement

* as the direct object
"You appear to be correct."
            -------------   direct object

"He asked me to help him."
          --------------  当不定式有actor时，这个actor可能会被省略掉。 'me to help him' 整体为 direct object
             -----------  在P220中，'to help him' 称为object complement

## as an Adjective           
"I have a paper to write before class."
                ----------------------  adjective. 不定式修饰它前面的名词paper，为该名词提供更多信息
"This is a good place to start reading."
                      ----------------  adjective. 不定式修饰它前面的名词place，为该名词提供更多信息

## as an Adverb
"I started running to improve my health."
                   --------------------- adverb. 不定式修饰动词running，描述该action发生的原因。称为 infinitives of purpose  
            
"We must leave now [in order | so as] to catch our train."
                                      ------------------   adverb. 不定式修饰动词leave
                    -----------------                      使用in order/so as可为infinitive of purpose添加形式上的强调


                   
# Modifier
Modifier = Adjectival | Adverbial

-----------------------------   Adjective
------------                    Attributive Adjective  (appear before the [pro]noun)
            ---------------     Predicative Adjective  (appear after the noun, connected by a linking verb)
            --------            Subject Complement     (describe the subject follow a linking verb)
                    -------     Object Complement      (describe the direct object of non-linking verbs



-----------------------------   Adjectival(Adjective, Adjective Phrase, Adjective Clause)
----------------                Modefier
                -------------   Complement #P310


-----------------------------   Adverbial(Adverb, Adverb Phrase, Adverb Clause) #P360
-------------                   Modefier (Adverbial Adjunct) #P870
             ----------------   Complement #P858

## Common modifier mistakes  #P867
1. Misplaced modifiers
place a modifier too far away from the thing it describes
"Burton was driving around the countryside while his friend sang songs slowly."
                                                                       ------   adverb slowly is modifying sang
"Burton was slowly driving around the countryside while his friend sang songs."
            ------                                                              adverb slowly is modifying driving

* often occur with participle phrases
"Terrified after watching a scary movie, my father had to comfort my little sister."
 --------------------------------------                                             participle phrase seems like modify 'my father'

"My father had to comfort my sister, terrified after watching a scary movie."
                                     ---------------------------------------  participle phrase modify 'my little sister'

2. Squinting modifiers
use a modifier in the correct technical position, but its meaning can be misconstrued because of another word that is too close to it

"The way he sings so often annoys me."
                  --------               'So often' seems like it could be modifying either sings or annoys
"The way he sings so often is annoying to me."
                  --------                    'So often' modifies 'sings'                
"The way he sings annoys me so often."
                            --------           'So often' modifies 'annoys'   

3. don’t clearly state the noun that is supposed to be modified by the modifying phrase, especially common with participle phrases
"Walking down the road, the birds were singing."
 ---------------------                            it seems like modify 'the birds' 

"Walking down the road, I heard the birds singing."
 ---------------------                             modify 'I' 



 Q：
 1. finite verb and non-finite verb  #P118 P126
 2. 