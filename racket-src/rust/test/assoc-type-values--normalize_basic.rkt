#lang racket
(require redex/reduction-semantics
         "../../util.rkt"
         "../../ty/user-ty.rkt"
         "../grammar.rkt"
         "../prove.rkt"
         "../libcore.rkt"
         )

(module+ test
  (redex-let*
   formality-rust

   [(; trait Iterator { type Item; }
     Rust/TraitDecl_Iterator
     (term (trait Iterator[] where []
                  {
                   (type Item () : [] where [])
                   }))
     )

     (; struct Vec<T> { }
     Rust/AdtDecl_Vec<T>
     (term (struct Vec[(type T)]
             where []
             {})))

     (; struct Foo { }
     Rust/AdtDecl_Foo
     (term (struct Foo[]
             where []
             {})))

    (; impl<T> Iterator for Vec<T> { type Item = T; }
     Rust/TraitImplDecl_Iterator_for_Vec<T>
     (term (impl[(type T)] Iterator[] for (Vec < T >)
                where []
                {
                 (type Item[] = T where [])
                 })))
    ]

   (;
    traced '()
           (test-equal
            (term (rust:is-program-ok ([libcore
                                        (crate C { Rust/TraitDecl_Iterator
                                                   Rust/AdtDecl_Vec<T>
                                                   Rust/AdtDecl_Foo
                                                   Rust/TraitImplDecl_Iterator_for_Vec<T>
                                                   })
                                        ]
                                       C)))
            #t)
           )

  (traced '()
          (test-equal
           (term (rust:query
                  ([(crate C { Rust/TraitDecl_Iterator
                               Rust/AdtDecl_Vec<T>
                               Rust/AdtDecl_Foo
                               Rust/TraitImplDecl_Iterator_for_Vec<T>
                             })]
                   C)
                  (?∀ [(type T)]
                       (?=> [(T : Iterator[])]
                            (?∃ [(type U)]
                                (< T as Iterator[] > :: Item[] == U))))
                  ))
           (term [(:- () ((()) ()))])
           )
          )
   )
  )