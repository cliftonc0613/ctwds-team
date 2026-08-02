#!/usr/bin/env bash
#
# Claude Company OS Installer
# Installs all 7 departments of skills from the Company OS chart.
#
# Usage:
#   bash install-claude-company-os.sh                 # install everything
#   bash install-claude-company-os.sh --dry-run       # show commands, change nothing
#   bash install-claude-company-os.sh --only dev,design
#   bash install-claude-company-os.sh --skip dev
#   bash install-claude-company-os.sh --scope local   # this project only, not every project
#
# Groups: work (small business + legal + finance), marketing, social, dev, design, seo
#
# Note on seo: the SEO department's core `/seo`, `/blog`, `/ads` engines are not
# installed by this script (no public marketplace to pull them from — install
# those separately). The `seo` group here only covers the newer standalone SEO
# skills bundled in this repo under skills/seo/ (the 5-skill AI-citation
# pipeline, competitive intelligence, reporting, and setup skills). See
# seo-skills.md for the full skill reference.
#
# Requires: claude CLI, git. Node 22.12+ needed for Impeccable and Transitions.
#
# Note: Impeccable and Taste both install into the Designers group. They
# overlap on frontend design, so try both and drop whichever you don't use.
#
# --scope local|global (default: global). This only affects skills that
# genuinely support both. What it does NOT affect:
#   - All plugin installs (claude plugin install) are always global. Claude
#     Code has no per-project plugin install mode.
#   - Impeccable always installs into the current directory by design, since
#     it reads that project's actual tokens and components.
#   - 97-dev uses its own installer, whose scope behavior isn't confirmed
#     here, so --scope does not touch it either.
# What it DOES affect: Taste, Transitions, the 4 Anthropic example skills, and
# the 12 bundled SEO skills.
# Local means these are only visible in whatever project you run this from.

set -uo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

ALL_GROUPS="work marketing social dev design seo"
SELECTED_GROUPS="$ALL_GROUPS"
DRY_RUN=0
SCOPE="global"

SKILLS_DIR=""   # set after arg parsing, depends on --scope
TMP_DIR="$(mktemp -d)"

SUCCEEDED=()
FAILED=()
SKIPPED=()

# Anthropic example skills pulled from anthropics/skills (no marketplace needed)
ANTHROPIC_SKILLS=(
  "skill-creator"
  "mcp-builder"
  "web-artifacts-builder"
  "brand-guidelines"
)

# Standalone SEO skills bundled directly in this repo (skills/seo/), no
# marketplace or plugin exists for these yet. Keep in sync with seo-skills.md
# sections 9-12.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLED_SEO_SKILLS=(
  "keyword-fanout-map"
  "seo-content-writer"
  "onpage-optimizer"
  "internal-link-architect"
  "ai-visibility-checker"
  "keyword-cannibalization-checker"
  "competitor-analysis"
  "competitive-landscape"
  "weekly-seo-report"
  "link-prospecting"
  "seo-project-setup"
  "seo-strategy"
)

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------

if [ -t 1 ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'
  YELLOW=$'\033[33m'; RED=$'\033[31m'; BLUE=$'\033[34m'; RESET=$'\033[0m'
else
  BOLD=""; DIM=""; GREEN=""; YELLOW=""; RED=""; BLUE=""; RESET=""
fi

header()  { printf "\n%s%s%s\n" "$BOLD$BLUE" "$1" "$RESET"; }
info()    { printf "  %s\n" "$1"; }
ok()      { printf "  %s%s%s\n" "$GREEN" "$1" "$RESET"; }
warn()    { printf "  %s%s%s\n" "$YELLOW" "$1" "$RESET"; }
err()     { printf "  %s%s%s\n" "$RED" "$1" "$RESET"; }
dim()     { printf "  %s%s%s\n" "$DIM" "$1" "$RESET"; }

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# ---------------------------------------------------------------------------
# Arg parsing
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1; shift ;;
    --only)
      SELECTED_GROUPS="$(printf '%s' "${2:-}" | tr ',' ' ')"; shift 2 ;;
    --skip)
      SKIP_LIST="$(printf '%s' "${2:-}" | tr ',' ' ')"
      NEW=""
      for g in $ALL_GROUPS; do
        keep=1
        for s in $SKIP_LIST; do [ "$g" = "$s" ] && keep=0; done
        [ $keep -eq 1 ] && NEW="$NEW $g"
      done
      SELECTED_GROUPS="$NEW"; shift 2 ;;
    --scope)
      SCOPE="${2:-}"
      if [ "$SCOPE" != "local" ] && [ "$SCOPE" != "global" ]; then
        err "Invalid --scope value: $SCOPE (must be local or global)"
        exit 1
      fi
      shift 2 ;;
    -h|--help)
      sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)
      err "Unknown option: $1"; exit 1 ;;
  esac
done

has_group() {
  for g in $SELECTED_GROUPS; do [ "$g" = "$1" ] && return 0; done
  return 1
}

if [ "$SCOPE" = "global" ]; then
  SKILLS_DIR="${HOME}/.claude/skills"
else
  SKILLS_DIR="./.claude/skills"
fi

# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

run() {
  local label="$1"; shift
  if [ $DRY_RUN -eq 1 ]; then
    dim "would run: $*"
    return 0
  fi

  local step_start
  step_start=$(wc -l < "$TMP_DIR/install.log" 2>/dev/null || echo 0)

  if "$@" >>"$TMP_DIR/install.log" 2>&1; then
    ok "$label"
    SUCCEEDED+=("$label")
    return 0
  fi

  # Command exited nonzero. Check whether that's because it's already
  # installed, not a real failure, before reporting it as one.
  local step_output
  step_output=$(tail -n +"$((step_start + 1))" "$TMP_DIR/install.log" 2>/dev/null)

  if printf '%s' "$step_output" | grep -qiE \
    'already installed|already exists|already added|is already present'; then
    ok "$label (already installed, skipped)"
    SUCCEEDED+=("$label")
    return 0
  fi

  err "$label failed. See log below."
  FAILED+=("$label")
  return 1
}

add_marketplace() {
  local repo="$1"
  claude plugin marketplace add "$repo" >>"$TMP_DIR/install.log" 2>&1
  return 0   # already-added is not a real failure
}

install_plugin() {
  local label="$1" repo="$2" spec="$3"
  add_marketplace "$repo"
  run "$label" claude plugin install "$spec"
}

# Guards against a known open bug in the `skills` CLI (vercel-labs/skills
# issues #851 and #1355): `npx skills add -a claude-code` writes the skill
# to .agents/skills/<name> (or ~/.agents/skills/<name> with -g) but does not
# reliably create the symlink Claude Code actually reads from at
# .claude/skills/<name>. Without this check, an install can report success
# while remaining completely invisible to Claude Code.
ensure_skill_symlink() {
  local skill_name="$1" scope="$2"
  local claude_dir agents_dir

  if [ "$scope" = "global" ]; then
    claude_dir="${HOME}/.claude/skills"
    agents_dir="${HOME}/.agents/skills"
  else
    claude_dir="./.claude/skills"
    agents_dir="./.agents/skills"
  fi

  if [ -e "$claude_dir/$skill_name" ]; then
    return 0   # Claude Code can already see it. Nothing to fix.
  fi

  if [ -d "$agents_dir/$skill_name" ]; then
    mkdir -p "$claude_dir"
    ln -s "$(cd "$agents_dir/$skill_name" && pwd)" "$claude_dir/$skill_name" \
      2>>"$TMP_DIR/install.log"
    if [ -e "$claude_dir/$skill_name" ]; then
      dim "  (fixed missing .claude/skills symlink for $skill_name)"
    else
      warn "  $skill_name installed but not visible to Claude Code."
      warn "  Expected symlink at: $claude_dir/$skill_name"
    fi
  fi
}

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------

header "Claude Company OS Installer"
[ $DRY_RUN -eq 1 ] && warn "DRY RUN. Nothing will be installed."
info "Groups: $(echo $SELECTED_GROUPS | tr ' ' ',')"
info "Scope: $SCOPE (affects Taste, Transitions, the Anthropic example skills, and the bundled SEO skills only)"

header "Checking prerequisites"

if ! command -v claude >/dev/null 2>&1; then
  err "claude CLI not found on PATH."
  err "Install Claude Code first, then re-run this script."
  exit 1
fi
ok "claude CLI found"

if ! command -v git >/dev/null 2>&1; then
  err "git not found on PATH. Required for the Anthropic example skills."
  exit 1
fi
ok "git found"

HAS_NPX=0
NODE_OK=0
if command -v npx >/dev/null 2>&1; then
  HAS_NPX=1
  ok "npx found"
  if command -v node >/dev/null 2>&1; then
    NODE_RAW="$(node --version 2>/dev/null)"
    NODE_MAJOR="$(printf '%s' "$NODE_RAW" | sed 's/^v//' | cut -d. -f1)"
    NODE_MINOR="$(printf '%s' "$NODE_RAW" | sed 's/^v//' | cut -d. -f2)"
    if [ "${NODE_MAJOR:-0}" -gt 22 ] 2>/dev/null; then
      NODE_OK=1
    elif [ "${NODE_MAJOR:-0}" -eq 22 ] && [ "${NODE_MINOR:-0}" -ge 12 ] 2>/dev/null; then
      NODE_OK=1
    fi
    if [ $NODE_OK -eq 1 ]; then
      ok "node $NODE_RAW"
    else
      warn "node $NODE_RAW found. Impeccable needs 22.12 or newer."
    fi
  else
    warn "node not found. Impeccable will be skipped."
  fi
else
  warn "npx not found. Impeccable, Taste, and Transitions will be skipped."
fi

mkdir -p "$SKILLS_DIR"

# ---------------------------------------------------------------------------
# 1. Small Business + Legal + Finance (Anthropic knowledge-work-plugins)
# ---------------------------------------------------------------------------

if has_group work; then
  header "Small Business, Legal, Finance"
  info "Source: anthropics/knowledge-work-plugins"
  add_marketplace "anthropics/knowledge-work-plugins"
  run "small-business plugin"  claude plugin install small-business@knowledge-work-plugins
  run "legal plugin"           claude plugin install legal@knowledge-work-plugins
  run "finance plugin"         claude plugin install finance@knowledge-work-plugins
else
  SKIPPED+=("work")
fi

# ---------------------------------------------------------------------------
# 2. Marketing (Corey Haines)
# ---------------------------------------------------------------------------

if has_group marketing; then
  header "Marketing"
  info "Source: coreyhaines31/marketingskills"
  install_plugin "marketing-skills" \
    "coreyhaines31/marketingskills" \
    "marketing-skills@marketingskills"
else
  SKIPPED+=("marketing")
fi

# ---------------------------------------------------------------------------
# 3. Social Media (Charlie Hills)
# ---------------------------------------------------------------------------

if has_group social; then
  header "Social Media"
  info "Source: charlie947/social-media-skills"
  install_plugin "social-media-skills" \
    "charlie947/social-media-skills" \
    "social-media-skills@social-media-skills"
  dim "Run voice-builder first. Every other social skill reads its output."
else
  SKIPPED+=("social")
fi

# ---------------------------------------------------------------------------
# 4. Developers
# ---------------------------------------------------------------------------

if has_group dev; then
  header "Developers"

  info "Superpowers (obra/superpowers-marketplace)"
  install_plugin "superpowers" \
    "obra/superpowers-marketplace" \
    "superpowers@superpowers-marketplace"

  info "Context7 (upstash/context7)"
  install_plugin "context7" \
    "upstash/context7" \
    "context7@context7-marketplace"

  info "Claude-Mem (thedotmack/claude-mem)"
  install_plugin "claude-mem" \
    "thedotmack/claude-mem" \
    "claude-mem@thedotmack"

  info "97-dev (DeevsDeevs/agent-system) scoped, single skill only"
  if [ $DRY_RUN -eq 1 ]; then
    dim "would run: curl -fsSL https://raw.githubusercontent.com/DeevsDeevs/agent-system/main/scripts/install.sh | bash -s -- --non-interactive --platform claude --skills 97-dev"
  else
    run "97-dev" bash -c \
      'curl -fsSL https://raw.githubusercontent.com/DeevsDeevs/agent-system/main/scripts/install.sh | bash -s -- --non-interactive --platform claude --skills 97-dev'
    dim "Scoped to 97-dev only. The Deevs marketplace also ships anti-ai-slop,"
    dim "golang-pro, polars-expertise, and persona workflow systems, not installed here."
  fi

  info "Astro Business Builder (cliftonc0613/astro-business-builder)"
  install_plugin "astro-business-builder" \
    "cliftonc0613/astro-business-builder" \
    "astro-business-builder@astro-business-builder"
  dim "Plugin name assumed to match repo name. Not independently verified"
  dim "against the actual .claude-plugin/plugin.json. If install fails,"
  dim "check the real plugin name and correct the @ suffix above."
else
  SKIPPED+=("dev")
fi

# ---------------------------------------------------------------------------
# 5. Designers
# ---------------------------------------------------------------------------

if has_group design; then
  header "Designers"

  info "UI UX Pro Max (nextlevelbuilder)"
  install_plugin "ui-ux-pro-max" \
    "nextlevelbuilder/ui-ux-pro-max-skill" \
    "ui-ux-pro-max@ui-ux-pro-max-skill"

  info "Impeccable (pbakaus/impeccable)"
  if [ $HAS_NPX -eq 1 ] && [ $NODE_OK -eq 1 ]; then
    run "impeccable" npx --yes impeccable install
    dim "Run /impeccable init inside Claude Code on first use."
  else
    warn "Skipped. Needs Node 22.12+. Then: npx impeccable install"
    SKIPPED+=("impeccable")
  fi

  if [ $HAS_NPX -eq 1 ]; then
    info "Taste (Leonxlnx/taste-skill), scope: $SCOPE"
    if [ "$SCOPE" = "global" ]; then
      run "taste-skill" npx --yes skills add Leonxlnx/taste-skill \
        --skill design-taste-frontend -a claude-code -g
    else
      run "taste-skill" npx --yes skills add Leonxlnx/taste-skill \
        --skill design-taste-frontend -a claude-code
    fi
    [ $DRY_RUN -eq 0 ] && ensure_skill_symlink "design-taste-frontend" "$SCOPE"
  else
    warn "Skipping Taste. Install Node, then re-run with --only design."
  fi

  if [ $HAS_NPX -eq 1 ]; then
    info "Transitions (Jakubantalik/transitions.dev), scope: $SCOPE"
    if [ "$SCOPE" = "global" ]; then
      run "transitions.dev" npx --yes skills add Jakubantalik/transitions.dev \
        -a claude-code -g
    else
      run "transitions.dev" npx --yes skills add Jakubantalik/transitions.dev \
        -a claude-code
    fi
    [ $DRY_RUN -eq 0 ] && ensure_skill_symlink "transitions.dev" "$SCOPE"
    dim "  (symlink check assumes folder name 'transitions.dev'. If this repo"
    dim "  installs under a different skill name, the check above may not"
    dim "  find it. Run: ls ~/.claude/skills/ (or ./.claude/skills/ for local)"
    dim "  to confirm the real folder name if Transitions doesn't show up.)"
  else
    warn "Skipping Transitions. Install Node, then re-run with --only design."
  fi

  dim "Impeccable and Taste both install. They overlap on the same job,"
  dim "polishing and steering frontend design, so Claude may reach for"
  dim "either one on a design request. Try both, then remove whichever"
  dim "you don't reach for. Neither uninstall damages your project files."
else
  SKIPPED+=("design")
fi

# ---------------------------------------------------------------------------
# 6. Anthropic example skills (direct copy, no marketplace)
# ---------------------------------------------------------------------------

if has_group dev || has_group design; then
  header "Anthropic example skills"
  info "Source: anthropics/skills, scope: $SCOPE"
  info "Destination: $SKILLS_DIR"

  if [ $DRY_RUN -eq 1 ]; then
    dim "would clone anthropics/skills and copy: ${ANTHROPIC_SKILLS[*]}"
  else
    if git clone --depth 1 --quiet \
        https://github.com/anthropics/skills.git \
        "$TMP_DIR/anthropic-skills" >>"$TMP_DIR/install.log" 2>&1; then
      for skill in "${ANTHROPIC_SKILLS[@]}"; do
        SRC="$TMP_DIR/anthropic-skills/skills/$skill"
        if [ -d "$SRC" ]; then
          rm -rf "${SKILLS_DIR:?}/$skill"
          cp -R "$SRC" "$SKILLS_DIR/$skill"
          ok "$skill"
          SUCCEEDED+=("$skill")
        else
          err "$skill not found in repo. It may have been renamed."
          FAILED+=("$skill")
        fi
      done
    else
      err "Could not clone anthropics/skills."
      FAILED+=("anthropics/skills clone")
    fi
  fi
fi

# ---------------------------------------------------------------------------
# 7. SEO (bundled skills, direct copy — no marketplace exists for these yet)
# ---------------------------------------------------------------------------

if has_group seo; then
  header "SEO (bundled skills)"
  info "Source: this repo's skills/seo/, scope: $SCOPE"
  info "Destination: $SKILLS_DIR"
  dim "Covers the newer standalone SEO skills only. The core /seo, /blog, /ads"
  dim "content engines are a separate install — see README.md."

  SEO_SRC_DIR="$SCRIPT_DIR/skills/seo"
  if [ ! -d "$SEO_SRC_DIR" ]; then
    err "skills/seo/ not found next to this script. Skipping."
    FAILED+=("seo skills bundle")
  else
    for skill in "${BUNDLED_SEO_SKILLS[@]}"; do
      SRC="$SEO_SRC_DIR/$skill"
      if [ ! -d "$SRC" ]; then
        err "$skill not found in skills/seo/. It may have been renamed."
        FAILED+=("$skill")
        continue
      fi
      DEST="$SKILLS_DIR/$skill"
      if [ -d "$DEST" ] && diff -rq "$SRC" "$DEST" >/dev/null 2>&1; then
        ok "$skill (already installed, skipped)"
        SUCCEEDED+=("$skill")
        continue
      fi
      if [ $DRY_RUN -eq 1 ]; then
        if [ -d "$DEST" ]; then
          dim "would update $skill at $DEST (contents differ from repo)"
        else
          dim "would copy $skill to $DEST"
        fi
        continue
      fi
      rm -rf "${DEST:?}"
      cp -R "$SRC" "$DEST"
      ok "$skill"
      SUCCEEDED+=("$skill")
    done
  fi
else
  SKIPPED+=("seo")
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

header "Summary"

if [ $DRY_RUN -eq 1 ]; then
  info "Dry run complete. Re-run without --dry-run to install."
  exit 0
fi

printf "  %sInstalled: %d%s\n" "$GREEN" "${#SUCCEEDED[@]}" "$RESET"
for s in "${SUCCEEDED[@]:-}"; do [ -n "$s" ] && dim "  $s"; done

if [ "${#FAILED[@]}" -gt 0 ]; then
  printf "\n  %sFailed: %d%s\n" "$RED" "${#FAILED[@]}" "$RESET"
  for f in "${FAILED[@]}"; do err "  $f"; done
  printf "\n"
  warn "Last 25 log lines:"
  tail -n 25 "$TMP_DIR/install.log" | sed 's/^/    /'
  printf "\n"
  info "Full log copied to: ${HOME}/claude-os-install.log"
  cp "$TMP_DIR/install.log" "${HOME}/claude-os-install.log" 2>/dev/null || true
fi

header "Next steps"
info "1. Restart Claude Code so the new plugins load."
info "2. Run /plugin to confirm everything shows up."
if has_group dev; then
  info "3. Claude-Mem needs its worker started. Run: npx claude-mem install"
fi
if has_group social; then
  info "4. Social skills need voice-builder run first, plus APIFY_API_TOKEN"
  info "   and GOOGLE_AI_API_KEY for post-scorer and reels-scripting."
fi
if has_group dev; then
  info "5. Context7 works anonymously. For higher limits, set CONTEXT7_API_KEY."
fi
if has_group design; then
  info "6. Run /impeccable init once per project. It reads your tokens and"
  info "   components instead of overwriting them, so run it from the repo root."
  info "7. Optional: npx impeccable detect src/ as a PR gate. Exits nonzero on findings."
  info "8. Optional: Impeccable Chrome extension runs the detector on any live page."
fi
printf "\n"

[ "${#FAILED[@]}" -gt 0 ] && exit 1
exit 0
