enum Game {
  HATSUNE_MIKU_PROJECT_DIVA_ARCADE(name: 'Hatsune Miku Project DIVA Arcade'),
  MAIMAI(name: 'maimai FiNALE'),
  MAIMAI_DX(name: 'maimai DX'),
  MAIMAI_DX_INTERNATIONAL(name: 'maimai DX (International)'),
  CHUNITHM(name: 'CHUNITHM PARADISE LOST'),
  CHUNITHM_NEW(name: 'CHUNITHM NEW'),
  CHUNITHM_NEW_INTERNATIONAL(name: 'CHUNITHM NEW (International)'),
  ONGEKI(name: 'O.N.G.E.K.I.'),
  DANCERUSH_STARDOM(name: 'DANCERUSH STARDOM'),
  DANCEDANCEREVOLUTION(name: 'DanceDanceRevolution'),
  DANCEDANCEREVOLUTION_20TH_ANNIVERSARY_MODEL(name: 'DanceDanceRevolution 20th anniversary model'),
  GITADORA_DRUMMANIA(name: 'GITADORA DrumMania'),
  GITADORA_GUITARFREAKS(name: 'GITADORA GuitarFreaks'),
  BEATMANIA_IIDX(name: 'beatmania IIDX'),
  BEATMANIA_IIDX_LIGHTNING_MODEL(name: 'beatmania IIDX LIGHTNING MODEL'),
  JUBEAT(name: 'jubeat'),
  MUSECA(name: 'MUSECA'),
  POP_N_MUSIC(name: 'pop\'n music'),
  REFLEC_BEAT(name: 'REFLEC BEAT'),
  SOUND_VOLTEX(name: 'SOUND VOLTEX'),
  SOUND_VOLTEX_VALKYRIE_MODEL(name: 'SOUND VOLTEX -Valkyrie  model-');

  const Game({
    required this.name,
  });

  final String name;
}

