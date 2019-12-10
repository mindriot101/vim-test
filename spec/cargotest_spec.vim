source spec/support/helpers.vim

describe "Cargo"

  before
    cd spec/fixtures/cargo
  end

  after
    call Teardown()
    cd -
  end

  it "runs all for nearest tests"
    view +7 src/lib.rs
    TestNearest

    Expect g:test#last_command == 'cargo test tests::it_works -- --exact'
  end

  it "runs all for nearest tests in modules"
    SKIP "not implemented separate modules yet"
    view +5 src/foo.rs
    TestNearest

    Expect g:test#last_command == 'cargo test foo::tests::it_works -- --exact'
  end

  it "runs all for file tests"
    view normal_test.rs
    TestFile

    Expect g:test#last_command == 'cargo test'
  end

  it "runs test suites"
    view normal_test.rs
    TestSuite

    Expect g:test#last_command == 'cargo test'
  end

end

