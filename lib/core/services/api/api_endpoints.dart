/// api_endpoints.dart
/// Centralisation des points d'accès (endpoints) de l'API.
/// Permet une gestion centralisée et typée des URLs pour les appels réseau.
/// Modifiez ici pour adapter les routes selon votre backend/API.

library;

class ApiEndpoints {
  // ===== Authentification =====
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // ===== Utilisateur =====
  static const String userProfile = '/users/profile';
  static const String users = '/users'; // GET: liste, POST: création
  static const String getUser = '/users'; // /users/:id
  static const String createUser = '/users'; // POST
  static const String updateUser = '/users'; // /users/:id (PUT/PATCH)
  static const String deleteUser = '/users'; // /users/:id (DELETE)

  // ===== Classes =====
  static const String listClasses = '/classes'; // GET
  static const String classDetail = '/classes'; // /classes/:id

  // ===== Groupes de classe =====
  static const String classGroups = '/class-groups'; // /class-groups/:id

  // ===== Emploi du temps (planning) =====
  static const String schedules = '/schedules'; // /schedules/:id

  // ===== Présences =====
  static const String attendances = '/attendances'; // /attendances/:id

  // ===== Paiements =====
  static const String payments = '/payments'; // /payments/:id

  // ===== Fichiers virtuels =====
  static const String virtualFiles = '/virtual-files'; // /virtual-files/:id

  // ===== Messages et messagerie =====
  static const String messageThreads = '/messages/threads'; // /messages/threads/:id
  static const String sendMessage = '/messages/send';
  static const String getMessageThread = '/messages/threads'; // /messages/threads/:id
  static const String deleteMessage = '/messages/threads'; // /messages/threads/:id (DELETE)
  static const String getMessagesByThreadId = '/messages/threads'; // /messages/threads/:id/messages
  static const String createMessageThread = '/messages/threads'; // POST: création d'un nouveau thread
  static const String updateMessageThread = '/messages/threads'; // /messages/threads/:id (PUT/PATCH)
  static const String getMessageThreadParticipants = '/messages/threads/participants'; // /messages/threads/:id/participants
  static const String addParticipantToThread = '/messages/threads/participants'; // POST: /messages/threads/:id/participants
  static const String removeParticipantFromThread = '/messages/threads/participants'; // DELETE: /messages/threads/:id/participants/:participantId
  static const String getDirectMessages = '/messages/direct'; // GET: /messages/direct/:userId
  static const String createDirectMessage = '/messages/direct'; // POST: création d'un message direct
  static const String getDirectMessage = '/messages/direct'; // /messages/direct/:id
  static const String deleteDirectMessage = '/messages/direct'; // /messages/direct/:id (DELETE)
  static const String getDirectMessageParticipants = '/messages/direct/participants'; // /messages/direct/:id/participants
  static const String addParticipantToDirectMessage = '/messages/direct/participants'; // POST: /messages/direct/:id/participants
  static const String removeParticipantFromDirectMessage = '/messages/direct/participants'; // DELETE: /messages/direct/:id/participants/:participantId
  static const String getMessageAttachments = '/messages/attachments'; // /messages/attachments/:messageId
  static const String uploadMessageAttachment = '/messages/attachments/upload'; // POST: upload d'une pièce jointe
  static const String deleteMessageAttachment = '/messages/attachments'; // DELETE: /messages/attachments/:attachmentId
  static const String markMessageAsRead = '/messages/threads/read'; // POST: /messages/threads/:id/read
  static const String markMessageAsUnread = '/messages/threads/unread'; // POST: /messages/threads/:id/unread
  static const String searchMessages = '/messages/search'; // POST: /messages/search (avec un body pour les critères de recherche)
  static const String getMessageStatistics = '/messages/statistics'; // GET: /messages/statistics (pour des statistiques globales)
  static const String getMessageNotifications = '/messages/notifications'; // GET: /messages/notifications (pour les notifications de nouveaux messages)
  static const String markAllMessagesAsRead = '/messages/threads/read-all'; // POST: /messages/threads/read-all (pour marquer tous les messages comme lus)
  static const String createGroup = '/messages/drafts'; // GET: /messages/drafts (pour récupérer les brouillons)

  // ===== Notifications =====
  static const String sendNotification = '/notifications/send';
  static const String notifications = '/notifications';
  static const String pushRegister = '/notifications/register-device';
  static const String pushUnregister = '/notifications/unregister-device';

  // ===== Notes (Grades) =====
  static const String getGrades = '/grades'; // GET: /grades?studentId=&classId=
  static const String createGrade = '/grades'; // POST: /grades
  static const String updateGrade = '/grades'; // /grades/:id (PUT/PATCH)
  static const String deleteGrade = '/grades'; // /grades/:id (DELETE)

  // ==== Sujets/Matières ====
  static const String subjects = '/subjects'; // /subjects/:id
  static const String subjectDetail = '/subjects'; // /subjects/:id
  static const String createSubject = '/subjects'; // POST: /subjects
  static const String updateSubject = '/subjects'; // /subjects/:id (PUT/PATCH)
  static const String deleteSubject = '/subjects'; // /subjects/:id (DELETE)
  static const String classSubjects = '/class-subjects'; // /class-subjects/:classId
  static const String classSubjectDetail = '/class-subjects'; // /class-subjects/:classId/:subjectId
  static const String createClassSubject = '/class-subjects'; // POST: /class-subjects
  static const String updateClassSubject = '/class-subjects'; // /class-subjects/:classId/:subjectId (PUT/PATCH)
  static const String deleteClassSubject = '/class-subjects'; // /class-subjects/:classId/:subjectId (DELETE)
  static const String classSubjectSchedule = '/class-subjects/schedule'; // /class-subjects/schedule/:classId/:subjectId
  static const String classSubjectAttendance = '/class-subjects/attendance'; // /class-subjects/attendance/:classId/:subjectId

  // ===== Ressources pédagogiques =====
  static const String resources = '/resources'; // /resources/:id
  static const String createResource = '/resources'; // POST: /resources
  static const String updateResource = '/resources'; // /resources/:id (PUT/PATCH)
  static const String deleteResource = '/resources';

  //==== Assignements =====
  static const String assignments = '/assignments'; // /assignments/:id
  static const String createAssignment = '/assignments'; // POST: /assignments
  static const String updateAssignment = '/assignments'; // /assignments/:id (PUT/PATCH)
  static const String deleteAssignment = '/assignments'; // /assignments/:id (DELETE)
  static const String assignmentDetail = '/assignments'; // /assignments/:id


  // ==== Divers : Ajoutez ici d'autres endpoints spécifiques à votre projet ====
}
