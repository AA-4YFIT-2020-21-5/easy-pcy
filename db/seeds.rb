domain = 'localhost'

verified_role, mod_role, admin_role, system_role = Role.create([
  { name: "Verified User" },
  { name: "Moderator", badge: true, moderation_privileges: true },
  { name: "Administrator", badge: true, moderation_privileges: true, administration_privileges: true },
  { name: "SYSTEM", badge: true, moderation_privileges: true, administration_privileges: true },
])

admin_account, nm, ce, mod_account = User.create([
  { email: "admin@#{domain}", display_name: 'Administrator', role: system_role,
    allow_profile_comments: false, hide_forum_activity: true, hide_course_activity: true,
    password_digest: '$2a$14$6DjhLtERqKmtlYEDCzzdgeKWy7mYk0g/lkT75Vpe0KnI7VIgOJ2Ci' },
  { email: "nm@#{domain}", display_name: 'NM', role: admin_role,
    allow_profile_comments: false, hide_forum_activity: true, hide_course_activity: true,
    password_digest: '$2a$14$Ki.Bq4xp5.mks5RHQaBHiOMKbFYhJWlh2LNnVl0hRm1exnd3TT/7C' },
  { email: "ce@#{domain}", display_name: 'CE', role: admin_role,
    allow_profile_comments: false, hide_forum_activity: true, hide_course_activity: true,
    password_digest: '$2a$14$8tc3pia0L21Xzke9VOocYeJ6aDRFd7tAlBirREWYOcXftzVno15EC' },
  { email: "mod@#{domain}", display_name: 'Moderator', role: mod_role,
    allow_profile_comments: false, hide_forum_activity: true, hide_course_activity: true,
    password_digest: '$ TODO' },
  { email: "user@#{domain}", display_name: 'User', role: verified_role,
    password_digest: '$ TODO' },
  { email: "invalid_user@#{domain}.fake", display_name: 'Invalid user',
    password_digest: '$ TODO' }
])

first_post, about_post = Post.create([
  { title: 'First post',
    author: admin_account,
    content: <<~CONTENT,
      Read the title... it's the first post made by the administrators of the forum.
      You can contact us at #{admin_account.email}.
    CONTENT
  },
  { title: 'About this project',
    author: admin_account,
    content: <<~'CONTENT',
      # TODO: write about this project text
    CONTENT
  }
])

first_post.comments.create([
  { author: nm, content: <<~'CONTENT' },
    This is a comment, which should be used for simple questions or additions to the post.
  CONTENT
  { author: nm, content: <<~'CONTENT' }
    An additional goal for this project is markdown-like support for the forum
    and embed references to other posts, comments or replies.
  CONTENT
])

about_comment, = about_post.comments.create([
  { author: admin_account, content: <<~CONTENT },
      == About us
      # TODO: write about us text
    CONTENT
  { author: ce, content: <<~CONTENT },
      == About CE
      Email: #{ce.email}
      # TODO: write about me text
    CONTENT
  { author: nm, content: <<~CONTENT }
      == About NM
      Email: #{nm.email}
      # TODO: write about me text
    CONTENT
])

about_comment.replies.create([
 { author: nm, content: 'Signed, NM' },
 { author: ce, content: 'Signed, CE' }
])
