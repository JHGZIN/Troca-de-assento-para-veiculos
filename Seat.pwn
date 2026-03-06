static const OneSeatVehicles[] = {
    425, 432, 441, 446, 448, 449, 453,
    454, 464, 465, 471, 472, 473, 481,
    484, 485, 486, 493, 501, 509, 510,
    511, 512, 513, 520, 530, 531, 532,
    539, 539, 564, 568, 571, 572, 574,
    601
};

static const TwoSeatVehicles[] = {
    401, 402, 403, 406, 408, 411, 413, 413,
    415, 417, 419, 422, 423, 424, 428, 429,
    433, 434, 436, 439, 440, 442, 443, 444,
    447, 451, 452, 455, 456, 457, 459, 460,
    460, 461, 462, 463, 468, 469, 474, 475,
    476, 477, 478, 480, 482, 488, 489, 491,
    494, 495, 496, 498, 499, 500, 502, 503,
    505, 506, 508, 514, 515, 517, 518, 519,
    521, 522, 523, 524, 525, 526, 527, 528,
    533, 534, 535, 536, 537, 538, 540, 541,
    542, 543, 544, 545, 546, 547, 548, 549,
    552, 553, 554, 555, 556, 557, 558, 559,
    561, 562, 563, 565, 573, 576, 577, 578,
    579, 581, 582, 583, 586, 587, 588, 589,
    592, 593, 600, 602, 603, 605, 609
};

static const FourSeatVehicles[] = {
    400, 404, 405, 407, 409, 410, 412, 416, 418,
    420, 421, 426, 427, 431, 437, 438, 445, 458,
    466, 467, 470, 479, 483, 487, 490, 492, 497,
    504, 507, 516, 529, 550, 560, 566, 567, 580,
    585, 596, 597, 598, 599, 604
};

stock bool:IsModelInList(modelid, const list[], size){
    for (new i = 0; i < size; i++)
        if (list[i] == modelid) return true;
    return false;
}

stock GetVehicleSeatCount(vehicleid){
    if (vehicleid == INVALID_VEHICLE_ID) return 0;
    new model = GetVehicleModel(vehicleid);

    if (IsModelInList(model, OneSeatVehicles, sizeof OneSeatVehicles))  return 1;
    if (IsModelInList(model, TwoSeatVehicles, sizeof TwoSeatVehicles))  return 2;
    if (IsModelInList(model, FourSeatVehicles, sizeof FourSeatVehicles)) return 4;
    return 4;
}

stock bool:Player_TryChangeSeat(playerid, seat){
    if (seat < 0 || seat > 3)
        return SendClientMessage(playerid, -1, "Use um assento entre 0 e 3."), false;

    if (!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Voce nao esta em um veiculo."), false;

    new vehicleid = GetPlayerVehicleID(playerid);
    new seats = GetVehicleSeatCount(vehicleid);
    if (seat >= seats) {
        new msg[96];
        format(msg, sizeof msg, "Este veiculo nao possui o banco %d (max: %d).", seat, seats - 1);
        SendClientMessage(playerid, -1, msg);
        return false;
    }

    if (GetPlayerVehicleSeat(playerid) == seat)
        return SendClientMessage(playerid, -1, "Voce ja esta nesse assento."), false;

    PutPlayerInVehicle(playerid, vehicleid, seat);
    SuccesMsg(playerid, "Assento trocado com sucesso.");
    return true;
}

CMD:seat(playerid, params[]){
    new seat;
    if (sscanf(params, "d", seat))
        return SendClientMessage(playerid, -1, "USO: /seat [0..3]  (0=driver, 1=pass, 2=tras esq, 3=tras dir)");

    Player_TryChangeSeat(playerid, seat);
    return 1;
}
