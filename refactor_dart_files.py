import os
import re
from pathlib import Path

def remove_comments(content):
    lines = content.split('\n')
    result = []
    in_multiline_comment = False

    for line in lines:
        if line.strip().startswith('// GENERATED CODE') or line.strip().startswith('// ignore_for_file'):
            result.append(line)
            continue

        if '/*' in line and '*/' in line and line.strip().startswith('/*'):
            continue

        if line.strip().startswith('///'):
            continue

        if line.strip().startswith('//'):
            continue

        cleaned_line = re.sub(r'//.*$', '', line)
        result.append(cleaned_line.rstrip())

    return '\n'.join(result)

def replace_sizedbox(content):
    replacements = {
        r'const SizedBox\(height: 4\)': 'AppSpacing.vertical(AppGaps.xs)',
        r'SizedBox\(height: 4\)': 'AppSpacing.vertical(AppGaps.xs)',
        r'const SizedBox\(height: 6\)': 'AppSpacing.vertical(6)',
        r'SizedBox\(height: 6\)': 'AppSpacing.vertical(6)',
        r'const SizedBox\(height: 8\)': 'AppSpacing.vertical(AppGaps.sm)',
        r'SizedBox\(height: 8\)': 'AppSpacing.vertical(AppGaps.sm)',
        r'const SizedBox\(height: 12\)': 'AppSpacing.vertical(12)',
        r'SizedBox\(height: 12\)': 'AppSpacing.vertical(12)',
        r'const SizedBox\(height: 16\)': 'AppSpacing.vertical(AppGaps.md)',
        r'SizedBox\(height: 16\)': 'AppSpacing.vertical(AppGaps.md)',
        r'const SizedBox\(height: 20\)': 'AppSpacing.vertical(20)',
        r'SizedBox\(height: 20\)': 'AppSpacing.vertical(20)',
        r'const SizedBox\(height: 24\)': 'AppSpacing.vertical(AppGaps.lg)',
        r'SizedBox\(height: 24\)': 'AppSpacing.vertical(AppGaps.lg)',
        r'const SizedBox\(height: 32\)': 'AppSpacing.vertical(AppGaps.xl)',
        r'SizedBox\(height: 32\)': 'AppSpacing.vertical(AppGaps.xl)',
        r'const SizedBox\(width: 4\)': 'AppSpacing.horizontal(AppGaps.xs)',
        r'SizedBox\(width: 4\)': 'AppSpacing.horizontal(AppGaps.xs)',
        r'const SizedBox\(width: 8\)': 'AppSpacing.horizontal(AppGaps.sm)',
        r'SizedBox\(width: 8\)': 'AppSpacing.horizontal(AppGaps.sm)',
        r'const SizedBox\(width: 16\)': 'AppSpacing.horizontal(AppGaps.md)',
        r'SizedBox\(width: 16\)': 'AppSpacing.horizontal(AppGaps.md)',
        r'const SizedBox\(width: 32\)': 'AppSpacing.horizontal(AppGaps.xl)',
        r'SizedBox\(width: 32\)': 'AppSpacing.horizontal(AppGaps.xl)',
    }

    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)

    return content

def fix_relative_imports(content, file_path):
    lines = content.split('\n')
    result = []

    for line in lines:
        if line.strip().startswith('import ') and ("'../" in line or '"../' in line):
            import_match = re.search(r"import ['\"](\.\./.*?)['\"];", line)
            if import_match:
                rel_path = import_match.group(1)
                abs_path =rel_path.replace('../', '').replace('./', '')
                new_line = f"import 'package:toko_online_sederhana/{abs_path}';"
                result.append(new_line)
                continue
        result.append(line)

    return '\n'.join(result)

def ensure_spacing_import(content):
    if 'AppSpacing' in content or 'AppGaps' in content:
        if "import 'package:toko_online_sederhana/core/utils/spacing.dart';" not in content:
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if line.strip().startswith('import ') and 'package:' in line:
                    lines.insert(i + 1, "import 'package:toko_online_sederhana/core/utils/spacing.dart';")
                    break
            content = '\n'.join(lines)
    return content

def process_dart_file(file_path):
    if file_path.name.endswith('.g.dart'):
        return False

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    content = fix_relative_imports(content, file_path)
    content = remove_comments(content)
    content = replace_sizedbox(content)
    content = ensure_spacing_import(content)

    content = '\n'.join([line for line in content.split('\n') if line.strip() or not line])

    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    lib_path = Path(r'c:\Users\dhans\reference-projects\toko_online_sederhana\lib')
    processed = 0

    for dart_file in lib_path.rglob('*.dart'):
        if process_dart_file(dart_file):
            processed += 1
            print(f"Processed: {dart_file.relative_to(lib_path)}")

    print(f"\nTotal files processed: {processed}")

if __name__ == '__main__':
    main()
