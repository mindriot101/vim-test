let test#rust#patterns = {
  \ 'test': ['\v\s*#\[test\]\s*fn\s+(\w+)\('],
  \ 'namespace': ['\v#\[cfg\(test\)\]\s*mod\s*(\w+)'],
  \}
