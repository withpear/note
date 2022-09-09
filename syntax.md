SimpleSentence = IndenpendentClause 
ComplexSentence = IndenpendentClause (DependentWord DenpendentClause)+ 
TODO IndenpendentClause不一定在句首

DependentWord = SubordinatingConjunction | RelativePronoun |...
SubordinatingConjunction = when | where | ...
RelativePronoun = whom | ...
1. IndenpendentClause也叫做main clause
2. IndenpendentClause必须包含完整的逻辑
3. DenpendentClause也叫做subordinate clauses
4. DenpendentClause依赖IndenpendentClause的逻辑

CompoundSentence = SimpleSentence (SentenceConjunction SimpleSentence)+
SentenceConjunction = , CoordinatingConjunction | ; ConjunctiveAdverb [,] | ;

CoordinatingConjunction = and | but | ...
ConjunctiveAdverb = as a result | therefore | ...

CompoundComplexSentence = ComplexSentence (ComplexSentence | SimpleSentence)+

Clause = Subject Predicate    
TODO 不同于CompleteSentence, clause in impretive sentence and non-finite clauses不遵守以上规则

Predicate = Verb | VerbPhrase
VerbPrase = Verb (Object | Modifier)
Subject = Noun | Pronoun | PhraseOfNounOrPronoun
