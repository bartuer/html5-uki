class UkiIncludeToken
  INCLUDE_REGEXP = %r{((?:^|\n)[^\n]\W|^|\n)\s*include\s*\(\s*['"]([^"']+)["']\s*\)(?:\s*;)?(.*?\r?\n|$)}
  INCLUDE_CSS_REGEXP = %r{include_css\s*\(\s*['"]([^"']+)["']\s*\)}
  CJS_REGEXP = %r{=\s*["']?(([^"' ]+).cjs)}
  IMAGE_DATA_REGEXP = %r{\[[^"]*"([^"]+)"[^"]+"data:image/png;base64,([^"]+)"[^"\]]*(?:"([^"]+)"[^"\]]*)?\]}
end

