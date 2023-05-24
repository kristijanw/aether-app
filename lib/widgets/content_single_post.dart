import 'package:app/constant.dart';
import 'package:app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ContentSinglePost extends StatefulWidget {
  ContentSinglePost({super.key, required this.post});

  Post post;

  @override
  State<ContentSinglePost> createState() => _ContentSinglePostState();
}

class _ContentSinglePostState extends State<ContentSinglePost> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            Text(
              '${widget.post.title}',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: bgColorStatus(
                  widget.post.status!.statusName.toString(),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '${widget.post.status!.statusName}',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: txtColorStatus(
                      widget.post.status!.statusName.toString(),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '${widget.post.user!.name}'.toUpperCase(),
              style: GoogleFonts.montserrat(),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          children: [
            Text(
              'Servis preuzeo:',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 5),
            if (widget.post.repairman != null) ...{
              Text(
                '${widget.post.repairman!.name}',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
              ),
            } else ...{
              Text(
                'Serviser nije odabran',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
              ),
            }
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Wrap(
          children: [
            Text(
              'Datum početka popravka:',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              widget.post.arrival != null
                  ? '${widget.post.arrival}'
                  : 'Nije odabran',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          children: [
            Text(
              'Vrijeme:',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              widget.post.time != null
                  ? '${widget.post.time}'
                  : 'Nije odabrano',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          children: [
            Text(
              'Garancija:',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              widget.post.guarantee == 1 ? 'Ima' : 'Nema',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          children: [
            Text(
              'Uređaj:',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${widget.post.nameDevice}',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Text(
          'Opis:',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Wrap(
          children: [
            Text(
              '${widget.post.body}',
              style: GoogleFonts.montserrat(),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        if (widget.post.image != null) ...{
          Text(
            'Slika:',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('${widget.post.image}'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        },
      ],
    );
  }
}
