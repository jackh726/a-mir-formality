#![allow(non_snake_case)]

const PROGRAM: &str = "[
    crate core {
        trait Iterator<> where [] {
            type Item<>: [] where []
        }
        struct Vec<ty T> where [] {}
        struct Foo<> where [] {}
        impl<ty T> Iterator<> for Vec<T> where [] {
            type Item<> where [] = T
        }
    }
]";

#[test]
fn test_normalize_basic() {
    expect_test::expect![[r#"
        Ok(
            yes,
        )
    "#]]
    .assert_debug_eq(&formality_rust::test_can_prove_goal(
        PROGRAM,
        "for_all(<ty T> implies(
            [is_implemented(Iterator(T))],
            exists(<ty U> all(
                is_implemented(Iterator(T)),
                normalizes_to((alias (Iterator::Item) T), U),
            ))
        ))",
    ));
}
