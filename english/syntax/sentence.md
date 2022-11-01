# Sentence
## SimpleSentence  #P937 
SimpleSentence = IndenpendentClause                                            
* TODO IndenpendentClause不一定在句首
1. IndenpendentClause也叫做main clause
2. IndenpendentClause必须包含完整的逻辑
3. DenpendentClause也叫做subordinate clauses
4. DenpendentClause依赖IndenpendentClause的逻辑

## CompoundSentence  #P945
CompoundSentence = SimpleSentence (SentenceConjunction SimpleSentence)+
SentenceConjunction = , CoordinatingConjunction
                      ; ConjunctiveAdverb [,]
                      ; 
                      , CorrelativeConjunction ?#P947
CoordinatingConjunction = and | but | ...
ConjunctiveAdverb = as a result | therefore | ...

✔ "She wanted to play tennis; he wanted to play basketball."
                            -
✔ "She wanted to play tennis, but he wanted to play basketball."
                            -----
✔ "She wanted to play tennis; however, he wanted to play basketball."
                            ----------
✔ "Neither does he need to go, nor does he want to go."
   -------                   -----


## ComplexSentence P950
ComplexSentence = IndenpendentClause (DependentWord DenpendentClause)+ 
                  DependentWord DenpendentClause , IndenpendentClause

DependentWord = SubordinatingConjunction | RelativePronoun | RelativeAdverb |...
SubordinatingConjunction = when | where | ...
RelativePronoun = whom | ...

## CompoundComplexSentence  
CompoundComplexSentence = ComplexSentence (ComplexSentence | SimpleSentence)+


## Comma
1. in CompoundSentence  P946
✔ "She wanted to play tennis; he wanted to play basketball."
                            -
✔ "She wanted to play tennis, but he wanted to play basketball."
                            -----
✔ "She wanted to play tennis; however, he wanted to play basketball."
                            ----------
✔ "Neither does he need to go, nor does he want to go."
   -------                   -----

2. in ComplexSentence   P952
when the dependent clause is placed first, we generally follow it with a comma

"He's going to pass his test even if he doesn't study."
 ----------------------------                            independent clause   
                             -------                     subordinating conjunction
                                     -----------------   dependent clause   

"Even if he doesn't study, he's going to pass his test."
 -------                                                subordinating conjunction
        -----------------                               dependent clause   
                         -                              comma
                          ---------------------------- independent clause   

3. in Restrictive and non-restrictive relative clauses P442
* Restrictive relative clauses does not need any commas
• "The house where I was born is a very special place."
             ----------------                           restrictive relative clause

* Non-restrictive relative clauses must be set apartuse by commas
• "Paris, where I want to live, is the most beautiful city in the world."
          --------------------                                              non-restrictive relative clause