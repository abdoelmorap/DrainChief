class BbbMeeting {
  BbbMeeting({
    this.id,
    this.createdBy,
    this.instructorId,
    this.classId,
    this.meetingId,
    this.topic,
    this.description,
    this.attendeePassword,
    this.moderatorPassword,
    this.date,
    this.time,
    this.datetime,
    this.welcomeMessage,
    this.dialNumber,
    this.maxParticipants,
    this.logoutUrl,
    this.record,
    this.duration,
    this.isBreakout,
    this.moderatorOnlyMessage,
    this.autoStartRecording,
    this.allowStartStopRecording,
    this.webcamsOnlyRorModerator,
    this.logo,
    this.copyright,
    this.muteOnStart,
    this.webcamsOnlyForModerator,
    this.lockSettingsDisableCam,
    this.lockSettingsDisableMic,
    this.lockSettingsLockOnJoin,
    this.lockSettingsLockOnJoinConfigurable,
    this.joinViaHtml5,
    this.lockSettingsDisablePrivateChat,
    this.lockSettingsDisablePublicChat,
    this.lockSettingsDisableNote,
    this.lockSettingsLockedLayout,
    this.lockSettingsLockOnOin,
    this.lockSettingsSockOnJoinConfigurable,
    this.guestPolicy,
    this.redirect,
    this.bbbMeetingJoinViaHtml5,
    this.state,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic createdBy;
  dynamic instructorId;
  dynamic classId;
  String? meetingId;
  String? topic;
  dynamic description;
  String? attendeePassword;
  String? moderatorPassword;
  String? date;
  String? time;
  String? datetime;
  dynamic welcomeMessage;
  dynamic dialNumber;
  dynamic maxParticipants;
  dynamic logoutUrl;
  dynamic record;
  dynamic duration;
  dynamic isBreakout;
  dynamic moderatorOnlyMessage;
  dynamic autoStartRecording;
  dynamic allowStartStopRecording;
  dynamic webcamsOnlyRorModerator;
  String? logo;
  String? copyright;
  dynamic muteOnStart;
  dynamic webcamsOnlyForModerator;
  dynamic lockSettingsDisableCam;
  dynamic lockSettingsDisableMic;
  dynamic lockSettingsLockOnJoin;
  dynamic lockSettingsLockOnJoinConfigurable;
  dynamic joinViaHtml5;
  dynamic lockSettingsDisablePrivateChat;
  dynamic lockSettingsDisablePublicChat;
  dynamic lockSettingsDisableNote;
  dynamic lockSettingsLockedLayout;
  dynamic lockSettingsLockOnOin;
  dynamic lockSettingsSockOnJoinConfigurable;
  String? guestPolicy;
  dynamic redirect;
  dynamic bbbMeetingJoinViaHtml5;
  String? state;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory BbbMeeting.fromJson(Map<String, dynamic> json) => BbbMeeting(
        id: json["id"],
        createdBy: json["created_by"],
        instructorId: json["instructor_id"],
        classId: json["class_id"],
        meetingId: json["meeting_id"],
        topic: json["topic"],
        description: json["description"],
        attendeePassword: json["attendee_password"],
        moderatorPassword: json["moderator_password"],
        date: json["date"],
        time: json["time"],
        datetime: json["datetime"],
        welcomeMessage: json["welcome_message"],
        dialNumber: json["dial_number"],
        maxParticipants: json["max_participants"],
        logoutUrl: json["logout_url"],
        record: json["record"],
        duration: json["duration"],
        isBreakout: json["is_breakout"],
        moderatorOnlyMessage: json["moderator_only_message"],
        autoStartRecording: json["auto_start_recording"],
        allowStartStopRecording: json["allow_start_stop_recording"],
        webcamsOnlyRorModerator: json["webcams_only_ror_moderator"],
        logo: json["logo"],
        copyright: json["copyright"],
        muteOnStart: json["mute_on_start"],
        webcamsOnlyForModerator: json["webcams_only_for_moderator"],
        lockSettingsDisableCam: json["lock_settings_disable_cam"],
        lockSettingsDisableMic: json["lock_settings_disable_mic"],
        lockSettingsLockOnJoin: json["lock_settings_lock_on_join"],
        lockSettingsLockOnJoinConfigurable:
            json["lock_settings_lock_on_join_configurable"],
        joinViaHtml5: json["join_via_html5"],
        lockSettingsDisablePrivateChat:
            json["lock_settings_disable_private_chat"],
        lockSettingsDisablePublicChat:
            json["lock_settings_disable_public_chat"],
        lockSettingsDisableNote: json["lock_settings_disable_note"],
        lockSettingsLockedLayout: json["lock_settings_locked_layout"],
        lockSettingsLockOnOin: json["lock_settings_lock_on_oin"],
        lockSettingsSockOnJoinConfigurable:
            json["lock_settings_sock_on_join_configurable"],
        guestPolicy: json["guest_policy"],
        redirect: json["redirect"],
        bbbMeetingJoinViaHtml5: json["join_via_html_5"],
        state: json["state"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "instructor_id": instructorId,
        "class_id": classId,
        "meeting_id": meetingId,
        "topic": topic,
        "description": description,
        "attendee_password": attendeePassword,
        "moderator_password": moderatorPassword,
        "date": date,
        "time": time,
        "datetime": datetime,
        "welcome_message": welcomeMessage,
        "dial_number": dialNumber,
        "max_participants": maxParticipants,
        "logout_url": logoutUrl,
        "record": record,
        "duration": duration,
        "is_breakout": isBreakout,
        "moderator_only_message": moderatorOnlyMessage,
        "auto_start_recording": autoStartRecording,
        "allow_start_stop_recording": allowStartStopRecording,
        "webcams_only_ror_moderator": webcamsOnlyRorModerator,
        "logo": logo,
        "copyright": copyright,
        "mute_on_start": muteOnStart,
        "webcams_only_for_moderator": webcamsOnlyForModerator,
        "lock_settings_disable_cam": lockSettingsDisableCam,
        "lock_settings_disable_mic": lockSettingsDisableMic,
        "lock_settings_lock_on_join": lockSettingsLockOnJoin,
        "lock_settings_lock_on_join_configurable":
            lockSettingsLockOnJoinConfigurable,
        "join_via_html5": joinViaHtml5,
        "lock_settings_disable_private_chat": lockSettingsDisablePrivateChat,
        "lock_settings_disable_public_chat": lockSettingsDisablePublicChat,
        "lock_settings_disable_note": lockSettingsDisableNote,
        "lock_settings_locked_layout": lockSettingsLockedLayout,
        "lock_settings_lock_on_oin": lockSettingsLockOnOin,
        "lock_settings_sock_on_join_configurable":
            lockSettingsSockOnJoinConfigurable,
        "guest_policy": guestPolicy,
        "redirect": redirect,
        "join_via_html_5": bbbMeetingJoinViaHtml5,
        "state": state,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}