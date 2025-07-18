// esbuild.config.mjs
import { build } from 'esbuild';

const isDev = process.argv[2] === 'development';

await build({
  entryPoints: ['main.ts'],
  bundle: true,
  minify: !isDev,
  sourcemap: isDev,
  outfile: 'main.js',
  target: 'es2020',
  platform: 'browser',
  format: 'cjs',
  logLevel: 'info',
  external: ['obsidian'], // ✅ Add this line to avoid bundling 'obsidian'
});
